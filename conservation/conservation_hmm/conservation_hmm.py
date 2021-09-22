#!/usr/bin/env python3

from argparse import ArgumentParser
from os import environ, path
import subprocess
import random


try:
    HMMER_DIR = environ["HMMER_DIR"]
except KeyError:
    HMMER_DIR = ""


def _generate_msa(fasta_file, database_file, working_directory):
    unweighted_msa_file = (
        path.join(working_directory, path.basename(fasta_file)) + ".sto"
    )
    subprocess.run(
        "{}phmmer -o /dev/null -A {} {} {}".format(
            HMMER_DIR, unweighted_msa_file, fasta_file, database_file
        ).split()
    )
    return unweighted_msa_file


def _select_sequences(unweighted_msa_file, max_seqs):
    sequence_names = []
    with open(unweighted_msa_file) as f:
        for line in f:
            if line.startswith("#=GS"):
                sequence_names.append(line.split()[1])
    if len(sequence_names) <= max_seqs:
        return None
    else:
        ss_file = unweighted_msa_file + ".ss"
        with open(ss_file, mode="w") as f:
            random.seed(666)
            for i in random.sample(sequence_names, k=max_seqs):
                f.write(i + "\n")
        return ss_file


def _generate_msa_sample(unweighted_msa_file, ss_file):
    unweighted_msa_sample_file = unweighted_msa_file + ".sample"
    subprocess.run(
        "{}esl-alimanip -o {} --seq-k {} {}".format(
            HMMER_DIR, unweighted_msa_sample_file, ss_file, unweighted_msa_file
        ).split(),
        stdout=subprocess.DEVNULL,
    )
    return unweighted_msa_sample_file


def _calculate_sequence_weights(unweighted_msa_file):
    weighted_msa_file = unweighted_msa_file + ".w"
    with open(weighted_msa_file, mode="w") as f:
        subprocess.run(
            "{}esl-weight {}".format(HMMER_DIR, unweighted_msa_file).split(),
            stdout=f,
            stderr=subprocess.DEVNULL,
        )
    return weighted_msa_file


def _calculate_information_content(weighted_msa_file):
    ic_file = weighted_msa_file + ".ic"
    r_file = weighted_msa_file + ".r"
    subprocess.run(
        "{}esl-alistat --icinfo {} --rinfo {} --weight {}".format(
            HMMER_DIR, ic_file, r_file, weighted_msa_file
        ).split(),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return ic_file, r_file


def _read_fasta_file(fasta_file):
    fasta_file_sequence = ""
    with open(fasta_file) as f:
        fasta_file_header = next(f).rstrip()
        for line in f:
            fasta_file_sequence += line.rstrip()
    return fasta_file_header, fasta_file_sequence


def _read_information_content(ic_file, r_file):
    try:
        with open(ic_file) as fi:
            information_content = [
                i.strip().split()[3]
                for i in fi
                if (i[0] != "#") and (i[0] != "/") and (i.lstrip()[0] != "-")
            ]
        with open(r_file) as fi:
            freqgap = [
                i.strip().split()[5]
                for i in fi
                if (i[0] != "#") and (i[0] != "/") and (i.lstrip()[0] != "-")
            ]
        return information_content, freqgap
    except FileNotFoundError:
        return None, None


def _write_feature(target_file, fasta_file_sequence, feature):
    with open(target_file, mode="w") as f:
        for (i, j), k in zip(enumerate(fasta_file_sequence), feature):
            f.write("\t".join((str(i), k, j)) + "\n")


def run_conservation_hmm(
    fasta_file,
    database_file,
    working_directory,
    target_file,
    msa=False,
    max_seqs=None,
):
    if msa:
        print("Option `--msa` is not yet implemented.")
    unweighted_msa_file = _generate_msa(fasta_file, database_file, working_directory)
    if max_seqs:
        ss_file = _select_sequences(unweighted_msa_file, max_seqs)
        if ss_file:
            unweighted_msa_sample_file = _generate_msa_sample(
                unweighted_msa_file, ss_file
            )
            weighted_msa_file = _calculate_sequence_weights(unweighted_msa_sample_file)
        else:  # `ss_file` is `None` if MSA contains fewer than `max_seqs` sequences
            weighted_msa_file = _calculate_sequence_weights(unweighted_msa_file)
    else:
        weighted_msa_file = _calculate_sequence_weights(unweighted_msa_file)
    ic_file, r_file = _calculate_information_content(weighted_msa_file)
    fasta_file_header, fasta_file_sequence = _read_fasta_file(fasta_file)
    information_content, freqgap = _read_information_content(ic_file, r_file)
    if information_content:
        assert len(fasta_file_sequence) == len(information_content) == len(freqgap)
        _write_feature(target_file, fasta_file_sequence, information_content)
        _write_feature(target_file + ".freqgap", fasta_file_sequence, freqgap)
    else:  # `information_content` is `None` if no MSA was generated
        _write_feature(
            target_file,
            fasta_file_sequence,
            ("-1000.0" for i in fasta_file_sequence),
        )
        _write_feature(
            target_file + ".freqgap",
            fasta_file_sequence,
            ("-1000.0" for i in fasta_file_sequence),
        )


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("fasta_file")
    parser.add_argument("database_file")
    parser.add_argument("working_directory")
    parser.add_argument("target_file")
    parser.add_argument("--msa", action="store_true")
    parser.add_argument("--max_seqs", type=int)
    args = vars(parser.parse_args())
    run_conservation_hmm(**args)

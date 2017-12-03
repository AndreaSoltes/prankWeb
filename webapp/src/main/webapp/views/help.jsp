<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout>
    <jsp:attribute name="header_after">
        <style type="text/css">
            code {
                white-space: pre;
            }

            .inline-image {
                height: 1em;
            }

            body::after {
                background-image: url(/images/proteins.png);
                opacity: 0.1;
                top:0;
                bottom:0;
                left: 0;
                right: 0;
                display: block;
                content: "";
                width: 100%;
                height: 100%;
                background-size: cover;
                background-attachment: fixed;
                position: absolute;
                z-index: -1;
            }

            body{
                background-color: transparent;
                position: relative;
            }
        </style>
    </jsp:attribute>
    <jsp:body>
        <div class="container">
            <h1 id="user-guide">User guide</h1>
            <p>PrankWeb is a web-based application that allows to predict and visualize
                protein-ligand
                binding sites. Furthermore, it allows to compare the location of predicted pockets
                with
                highly conserved areas as well as actual ligand binding sites. All one needs to use
                PrankWeb is a device with a web-browser that supports WebGL.</p>
            <h2 id="specify-what-protein-to-analyze">Specify what protein to analyze</h2>
            <p>There are two options to analyze a protein. A protein PDB file can be uploaded
                from user's computer, or PrankWeb can download it automatically from PDB database
                provided the protein identification code.</p>
            <img src="/images/input_form.png" class="img-responsive center-block"/>
            <ol>
                <li>To analyze a protein from PDB database,
                    one has to know its identification code and enter it on the PrankWeb
                    homepage.</li>

                <li>For analysis of custom PDB file,
                upload it by clicking the browse button. Please note that it might take a while
                before PrankWeb analyzes the custom file. For description of PDB format, please see its
                official documentation.<a href="#fn3" class="footnoteRef"
                                          id="fnref3"><sup>2</sup></a></li>
            </ol>
            <h3>Homology</h3>
            <p>Besides selecting what protein to analyze, one can also specify whether evolutionary
                conservation should be included in the prediction model by checking the "Run
                conservation analysis" checkbox. PrankWeb contains <b>two
                pretrained models</b> for pocket prediction. Note that calculating
                conservation score for user-defined protein file can significantly increase the time
                of analysis unless you specify its PDB identification code or upload multiple
                sequence alignments for homology calculation.</p>
            <p>There are three ways how to calculate the conservation score for the protein.</p>
            <ol>
                <li>You can specify custom alignment file, using which PrankWeb will
                    calculate the conservation score for your protein.</li>
                <li>If you know the PDB code of you protein, you can specify in the the
                    textbox and PrankWeb will calculate the homology from the alignment in
                    <a href="http://swift.cmbi.ru.nl/gv/hssp/">HSSP</a> database.</li>
                <li>Fallback method: If any of the previous methods fails or neither pdb
                    code nor the alignment file is specified, PrankWeb will calculate the
                    conservation score automatically using alignment of similar proteins.
                    For details see the
                    <a href="/other/thesis.pdf" target="_blank">original thesis.</a></li>
            </ol>
            <h2 id="visualization">Visualization</h2>
            <img src="/images/vis.png" class="img-responsive center-block"/>
            <p>Once the protein visualization is loaded, three main panels appear: sequence
                visualization, structural visualization and the control panel.</p>
            <h3 id="structural-visualization-1">Structural visualization</h3>
            <p>The largest panel contains the three-dimensional visualization of the protein. By
                default, the protein surface is displayed, and individual pocket areas are
                highlighted
                with different colors. If conservation is available, the protein surface is colored
                with
                11 shades of gray according to the conservation score of each residue. Darker color
                depicts higher conservation score. To display the protein in cartoon style, the
                protein
                surface can be hidden completely in the advanced control panel (explained below), or
                one
                can slab the protein view by scrolling the mouse wheel.</p>
            <h4 id="controls">Controls</h4>
            <p>The molecule can be rotated by moving mouse while holding left mouse button. On a
                touch
                device, just slide your finger. To zoom in or out, move your mouse while holding the
                right mouse button or use the pinch gesture on a touch display. In order to move the
                protein, do the same, but this time hold the wheel button. Lastly, for slabbing the
                protein, scroll the mouse wheel or use the three finger gesture.</p>
            <p>Using the buttons in the top-right corner, one can:</p>
            <ul>
                <li><p>Display a help window.</p></li>
                <li><p>Setup the scene such as the visualization background or the field of
                    view.</p>
                </li>
                <li><p>Create a snapshot of current visualization.</p></li>
                <li><p>Toggle advanced control panels.</p></li>
                <li><p>Toggle full-screen mode.</p></li>
            </ul>
            <p>By toggling the advanced control panel, one has full control over the content of the
                visualization. First, select what part of visualization to edit in the tree control
                on
                the left, then edit its properties or create new nodes using the right panel. For
                example, to increase the surface probe radius, click on the surface section on the
                left
                (subsection of polymer). Now, in the update visual section, expand the visual type
                section and use the probe radius trackbar to update the value. Please be cautious,
                because as of May 2017, LiteMol does not support Undo operation. It will be added
                soon,
                though. For more help with LiteMol, please visit its wiki page.<a href="#fn4"
                                                                                  class="footnoteRef"
                                                                                  id="fnref4"><sup>3</sup></a>
            </p>
            <img src="/images/vis_advanced.png" class="img-responsive center-block"/>
            <p>LiteMol visualization possibilities are very powerful. The visualization from
                figure above was achived by hiding the default protein surface and creating a
                small surface for the individual pockets.</p>
            <h3 id="sequence-visualization-1">Sequence visualization</h3>
            <p>The panel above protein 3D visualization displays protein sequence. All chains are
                concatenated and visualized at once. Chains can be identified by regions marked on
                the
                main sequence. Colored rectangles depict areas with predicted pockets and real
                binding
                areas (if available). Real binding sites are residues within 4 &#8491;
                from any ligand atom. If available, conservation scores are portrayed using a bar
                chart.
                As one hovers over the sequence with mouse, the residues are highlighted in the 3D
                visualization. This feature allows to analyze the protein both from the structural
                and
                sequential point of view. By default, the sequence view is zoomed out so that the
                whole
                protein is displayed. You can use the trackbar control to zoom in, or select the
                area
                with mouse and zoom to the selection. A snapshot of the sequence can be captured and
                exported to SVG (Scalable Vector Graphics) file using the rightmost button.</p>
            <h2 id="pocket-panel">Pocket panel</h2>
            <p>The right panel contains several control buttons and a list of predicted pockets. Use
                the
                control buttons to download PrankWeb report, share the website or hide the sequence
                view. PrankWeb report is a ZIP package containing all following files:</p>
            <ul>
                <li><p>Original pdb file uploaded, or the protein file downloaded from RCSB PDB.</p>
                </li>
                <li><p>Prediction JSON file containing a list of pockets, their scores and their
                    location i.e. a list of atoms and residues forming the pocket. (Output of
                    P2Rank)</p></li>
                <li><p>PyMol script for offline visualization. (Output of P2Rank).</p></li>
                <li><p>Conservation scores for each residue of the protein calculated using JSD
                    method
                    (see the <a href="#thesis">original thesis</a> for more details). The file is in
                                TSV (Tab
                    Separated Values) format. First column identifies the index, second contains the
                    score and the last column contains the residues from multiple sequence
                    alignment.
                    The first characters in the last column are the residues of the analyzed protein
                    file.</p></li>
                <li><p>Multiple sequence alignments in FASTA format that were used to calculate
                    conservation score.</p></li>
            </ul>
            <p>In the pocket list, pocket name, rank, size and average conservation score (if
                available)
                is displayed for each pocket. Moreover, one can highlight the pocket is the 3D
                visualization by hovering <img src="/images/aim-icon.svg" alt="aim icon"
                                               class="inline-image"/> button.
                After
                clicking that button, the camera will zoom in to the pocket. By clicking the <img
                        src="/images/eye-icon.svg" alt="eye icon" class="inline-image"/> button, one
                can toggle the pocket
                visibility
                in both structural and sequence visualizations.</p>
            <h2 id="more-details">More details</h2>
            <p id="thesis">For more technical details of this project, please see
                <a href="/other/thesis.pdf">the original thesis document.</a></p>
            <div class="footnotes">
                <hr/>
                <ol>
                    <li id="fn2"><p>For example: <a href="http://prank.projekty.ms.mff.cuni.cz"
                                                    class="uri">http://prank.projekty.ms.mff.cuni.cz</a>.<a
                            href="#fnref2">↩</a></p></li>
                    <li id="fn3"><p>PDB Format specification available at: <a
                            href="http://www.wwpdb.org/documentation/file-format" class="uri">http://www.wwpdb.org/documentation/file-format</a>.<a
                            href="#fnref3">↩</a></p></li>
                    <li id="fn4"><p><a href="https://webchem.ncbr.muni.cz/Wiki/LiteMol:UserManual"
                                       class="uri">https://webchem.ncbr.muni.cz/Wiki/LiteMol:UserManual</a><a
                            href="#fnref4">↩</a></p></li>
                </ol>
            </div>
        </div>
    </jsp:body>
</t:layout>

#!/bin/bash                                                                                                                                                    
#takes subjects' Inverse warps and inverse affines to 
#transform labels in tempate space back to subject's
#native space for further processing further down the road
INPUT_FILE="/NMOMVPA/template/LPBA40_AIR/avg/LabelLPBA2studytemplate_Warped.nii.gz"
index_html="/data/miscelaneous/QA_website/antsCorticalThickness/LabelInNativeSpace/index.html"
echo " " > $index_html
echo "Server public id address is"
curl -s icanhazip
echo " "
echo " "
echo " "
for SUBJECT in /NMOMVPA/subjects/*
do
        SUBNAME=`basename ${SUBJECT}`
        SUB2TEMPLATEINVERSEWARP="/NMOMVPA/subjects/${SUBNAME}/sub2template_InverseWarp.nii.gz,0"
        SUB2TEMPLATEINVERSEWARP="[$SUB2TEMPLATEINVERSEWARP]"
        SUB2TEMPLATEAFFINE="/NMOMVPA/subjects/${SUBNAME}/sub2template_Affine.txt,1"
        SUB2TEMPLATEAFFINE="[$SUB2TEMPLATEAFFINE]"
        SUB_T1="/NMOMVPA/subjects/${SUBNAME}/T1.nii.gz"
        MOSAIC="/NMOMVPA/subjects/${SUBNAME}/labelonT1mosaicview.png"
        LABELINSUBSPACE="/NMOMVPA/subjects/${SUBNAME}/LabelInSubSpace.nii.gz"
        LABELINSUBSPACERGB="/NMOMVPA/subjects/${SUBNAME}/LabelInSubSpaceRGB.nii.gz"
        MOSAICPNG="/NMOMVPA/subjects/${SUBNAME}/mosaicLabelOnCortex.png"
        MOSAICPNGWEB="/data/miscelaneous/QA_website/antsCorticalThickness/LabelInNativeSpace/${SUBNAME}.png"
        BRAINEXTRACTIONMASK="/NMOMVPA/working/cortical_thickness/_subject_id_${SUBNAME}/corticalthickness/antsCT_BrainExtractionMask.nii.gz"
        APPLYWARPCOMMAND="antsApplyTransforms -d 3 -i ${INPUT_FILE} -r ${SUB_T1}" 
        APPLYWARPCOMMAND="${APPLYWARPCOMMAND} -t ${SUB2TEMPLATEAFFINE} -t ${SUB2TEMPLATEINVERSEWARP} -o  ${LABELINSUBSPACE}"
        APPLYWARPCOMMAND="${APPLYWARPCOMMAND} --interpolation NearestNeighbor"
        echo "Warps were applied."
        conversion="${ANTSPATH}/ConvertScalarImageToRGB 3 ${LABELINSUBSPACE}"
        conversion="${conversion} ${LABELINSUBSPACERGB} none hsv none 0 255"
        MOSAICCOMMAND="${ANTSPATH}/CreateTiledMosaic -i ${SUB_T1} -r ${LABELINSUBSPACERGB}"
        MOSAICCOMMAND="${MOSAICCOMMAND} -o ${MOSAICPNG} -a 0.5 -t -1x-1 -d 2 -p mask+2"
        MOSAICCOMMAND="${MOSAICCOMMAND} -s [2,mask-2,mask+2] -x ${BRAINEXTRACTIONMASK}"
        echo "PNG quality control file copied, please point your browser to this server to see results."
        eval "$APPLYWARPCOMMAND"
        eval "$conversion"
        eval "$MOSAICCOMMAND"
        cp ${MOSAICPNG} ${MOSAICPNGWEB}
        html1st_line="<br><p><strong>${SUBNAME}</strong></p><hr>" 
        html2nd_line="<img src="\""${SUBNAME}.png"\"" alt="\""${SUBNAME}"\""width="\""1000"\"" height="\""800"\""><hr>"
        echo "$html1st_line" >> $index_html
        echo "$html2nd_line" >> $index_html
        rm -f "${LABELINSUBSPACERGB}"
  done

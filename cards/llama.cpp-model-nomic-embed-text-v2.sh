#!/bin/bash

cd "$(dirname "$0")"

source common.sh

echo -e "
 ${CC}   ${CT}llama.cpp                                model   

              ${CT}   Nomic Embed Text V2   ${CC}

                  ${CC}author: ${CA}Nomic ${CC}
                 ${CC}license: ${CA}Apache-2.0 ${CC}

        ${CC}capab: ${CA}Text, Multilingual ${CC}
        ${CC} uses: ${CA}Search, RAG, Clustering, etc. ${CC}

        ${CC} attn: ${CA}Multi-Head   ${CC}| head size: ${CA}64 ${CC}
        ${CC}param: ${CA}475M-A305M   ${CC}| embd size: ${CA}768 ${CC}
        ${CC} exps: ${CA}8 (2 active) ${CC}|  ctx size: ${CA}2048 ${CC}


    ${TC}                                             ${CC}
    ${TC}  > llama-server                             ${CC}
    ${TC}      ${TA}-hf ggml-org/Nomic-Embed-Text-V2-GGUF  ${CC}
    ${TC}      --ctx-size 2048 --embeddings           ${CC}
    ${TC}                                             ${CC}
" > card.txt

cat card.txt

echo -e "${C0}"

if [ $do_img -eq 1 ]; then
    cat card.txt | textimg --background 238,238,238,0 -F $p_fs -o output.png -f ../fonts/ProFontWinTweaked/ProFontWindows.ttf

    gg_add_frame output.png

    magick output.png -resize 1200x $(basename "$0" .sh).png

    printf "Image saved as $(basename "$0" .sh).png\n"
fi

exit 0

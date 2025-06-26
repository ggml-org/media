#!/bin/bash

cd "$(dirname "$0")"

source common.sh

echo -e "
 ${CC}   ${CT}llama.cpp                                model    

               ${CT}        Gemma 3n          ${CC}

              ${CC}author: ${CA}Google DeepMind${CC}
             ${CC}license: ${CA}Gemma Terms of Use ${CC}

        ${CC}-------------------------------------${CC}

         ${CC}capab: ${CA}Text, Vision, Audio ${CC}
         ${CC} uses: ${CA}Edge, low-end hardware ${CC}

         ${CC}sizes: ${CA}E2B, E4B ${CC}
        ${CC}layers: ${CA}20/(10), 20/(15) ${CC}

         ${CC} attn: ${CA}GQA ${CC} | head size: ${CA}256 ${CC}
         ${CC}heads: ${CA}8/2 ${CC} | embd size: ${CA}2048 ${CC}
         ${CC}  swa: ${CA}512 ${CC} |  ctx size: ${CA}32768 ${CC}


    ${TC}                                              ${CC}
    ${TC}  > llama-server                              ${CC}
    ${TC}      ${TA}-hf ggml-org/gemma-3n-E2B-it-GGUF:Q8_0  ${CC}
    ${TC}      --ctx-size 32768 --flash-attn           ${CC}
    ${TC}                                              ${CC}
    ${TC}  > llama-server                              ${CC}
    ${TC}      ${TA}-hf ggml-org/gemma-3n-E4B-it-GGUF:Q8_0  ${CC}
    ${TC}      --ctx-size 32768 --flash-attn           ${CC}
    ${TC}                                              ${CC} " > card.txt

cat card.txt

echo -e "${C0}"

if [ $do_img -eq 1 ]; then
    cat card.txt | textimg --background 255,255,255,0 -F $p_fs -o output.png -f ../fonts/ProFontWinTweaked/ProFontWindows.ttf

    gg_add_frame output.png

    magick output.png -resize 1200x $(basename "$0" .sh).png

    printf "Image saved as $(basename "$0" .sh).png\n"
fi

exit 0

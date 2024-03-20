#!/usr/bin/env bash
# Script by NsaGcl | Fabian Urra Morales
(
echo "fst q20"
perl ~/popoolation2/fst-sliding.pl --input q20.sync --output q20.fst --suppress-noninformative --min-count 6 --min-coverage 50 --max-coverage 200 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 500
echo "fst q10"
perl ~/popoolation2/fst-sliding.pl --input q10.sync --output q10.fst --suppress-noninformative --min-count 6 --min-coverage 50 --max-coverage 200 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 500
echo "fst q5"
perl ~/popoolation2/fst-sliding.pl --input q5.sync --output q5.fst --suppress-noninformative --min-count 6 --min-coverage 50 --max-coverage 200 --min-covered-fraction 1 --window-size 1 --step-size 1 --pool-size 500
echo "q20 fst to igv"
perl ~/popoolation2/export/pwc2igv.pl --input q20.fst --output q20.igv
echo "q10 fst to igv"
perl ~/popoolation2/export/pwc2igv.pl --input q10.fst --output q10.igv
echo "q5 fst to igv"
perl ~/popoolation2/export/pwc2igv.pl --input q5.fst --output q5.igv
echo "fst sliding window approach q20"
perl ~/popoolation2/fst-sliding.pl --input q20.sync --output q20_w500.fst --min-count 6 --min-coverage 50 --max-coverage 200 --min-covered-fraction 1 --window-size 500 --step-size 500 --pool-size 500
echo "fst sliding window approach q10"
perl ~/popoolation2/fst-sliding.pl --input q10.sync --output q10_w500.fst --min-count 6 --min-coverage 50 --max-coverage 200 --min-covered-fraction 1 --window-size 500 --step-size 500 --pool-size 500
echo "fst sliding window approach q50"
perl ~/popoolation2/fst-sliding.pl --input q5.sync --output q5_w500.fst --min-count 6 --min-coverage 50 --max-coverage 200 --min-covered-fraction 1 --window-size 500 --step-size 500 --pool-size 500
# importante: debes tener instalado el modulo Text::NSP en perl, para esto, en la terminal primero debes configurar cpan(es tan facil como ejecutar "cpan" y darle enter a todo, luego reiniciar la terminal
# y escribir cpan nuevamente, ya ejecutando cpan usar el comando "install Text::NSP", reiniciar la terminal y ejecutar los test
echo "fisher test q20"
perl ~/popoolation2/fisher-test.pl --input q20.sync --output q20.fet --min-count 6 --min-coverage 50 --max-coverage 200 --suppress-noninformative
echo "fisher test q10"
perl ~/popoolation2/fisher-test.pl --input q10.sync --output q10.fet --min-count 6 --min-coverage 50 --max-coverage 200 --suppress-noninformative
echo "fisher test q5"
perl ~/popoolation2/fisher-test.pl --input q5.sync --output q5.fet --min-count 6 --min-coverage 50 --max-coverage 200 --suppress-noninformative
echo finished
) 2<&1 | tee -a fst-fisher.log
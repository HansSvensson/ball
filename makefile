ball.prg: main.asm ball.asm gameBg.asm bat.asm score.asm game.asm gameOVer.asm menu.asm bonus.asm sound.asm bullet.asm howto.asm gameBgLevels.asm
	../tools/64tass -C -a -B -i main.asm -Wall --vice-labels -l viceLabels.l --list=out.lst -o ball.prg



exe: #Compile and add to main bin directory
	gcc -o bin/pm src/main.c -O2

sys: # copy to systems bin folder (requires sudo)
	sudo apt install jq
	cp bin/pm /usr/bin/pm
	mkdir /lib/pm
	cp src/feature.sh /lib/pm/feature
	cp src/init.sh /lib/pm/init

clean: # clean up tests folder for init
	rm -rf tests/bin/ tests/.pmd tests/docs/ tests/lib/ tests/src/ tests/tests tests/.git tests/README.md
	cp src/feature.sh /lib/pm/feature
	cp src/init.sh /lib/pm/init

clean: # clean up tests folder for init
	rm -rf tests/bin/ tests/.pmd tests/docs/ tests/lib/ tests/src/ tests/tests tests/.git tests/README.md

	
all:
	gcc -o bin/pm src/main.c -O2
	cp bin/pm /usr/bin/pm
	cp src/init.sh /lib/pm/init
	cp src/feature.sh /lib/pm/feature
	cp src/test.sh /lib/pm/test
	cp src/utls.sh /lib/pm/utls
	cp -r src/templates /lib/pm/
	cp src/webapp.py /lib/pm/webapp.py
# rm -rf tests/bin/ tests/.pmd tests/docs/ tests/lib/ tests/src/ tests/tests tests/.git tests/README.md

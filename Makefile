PY?=python
BUNDLE?=bundle
JEKYLL?=jekyll

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)
OUTPUTDIR=$(BASEDIR)/_site/


SSH_HOST=linux.eecs.tufts.edu
SSH_PORT=22
SSH_USER=
SSH_TARGET_DIR=/r/raja_www/public_html/

GITHUB_PAGES_BRANCH=master

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
endif

help:
	@echo 'Makefile for a jekyll Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve                          serve site at http://localhost:4000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload                 upload the web site via Dropbox    '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '   make s3_upload                      upload the web site via S3         '
	@echo '   make cf_upload                      upload the web site via Cloud Files'
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

# html:
#	cd content/reading_lists && python make_reading_list_csv_from_json.py
#	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
	$(BUNDLE) exec $(JEKYLL) serve


build:
	$(BUNDLE) exec $(JEKYLL) build	

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: build
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete --chmod=Du=rwx,Dg=rwxs,Do=rx,Fu=rw,Fg=rw,Fo=r --perms $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude


.PHONY: html help clean regenerate serve serve-global devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github

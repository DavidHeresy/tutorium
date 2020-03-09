# --- GIT ---

REPO = tutorium.git
HIDRIVE = $(shell echo "$$HIDRIVE")$(REPO)
GITHUB = $(shell echo "$$GITHUB")$(REPO)
GITLAB = $(shell echo "$$GITLAB")$(REPO)


init:
	git init
	git remote add origin $(HIDRIVE)
	git remote add github $(GITHUB)
	git remote add gitlab $(GITLAB)
	git add .
	git commit -a -m "initial commit"


push:
	#
	#
	# --- PUSH MASTER TO HIDRIVE ---
	#
	git push origin master
	#
	#
	# --- PUSH MASTER TO GITHUB ---
	#
	git push github master
	#
	#
	# --- PUSH MASTER TO GITLAB ---
	#
	git push gitlab master


# --- PYTHON ---

REQUIREMENTS = requirements.txt
VENV = venv
ACTIVATE = activate 
PY = ./$(VENV)/bin/python
PIP = ./$(VENV)/bin/pip
.SILENT: freeze


venv:
	#
	#
	# --- CREATE PYTHON VENV ---
	#
	python3.8 -m venv $(VENV)
	#
	#
	# --- UPDATE PIP ---
	#
	$(PIP) install --upgrade pip
	#
	#
	# --- INSTALL GRIP FOR README PREVIEW ---
	#
	$(PIP) install grip 
	#
	#
	# --- INSTALL PYTHON REQUIREMENTS ---
	#
	test -f $(REQUIREMENTS-PY) \
	&& $(PIP) install -r $(REQUIREMENTS-PY) \
	|| exit 0
	#
	#
	# --- CREATE PYTHON ACTIVATION SCRIPT ---
	#
	echo "#!/bin/sh" > $(ACTIVATE)
	echo "# Usage: $ source $(ACTIVATE)" >> $(ACTIVATE)
	echo "source $(VENV)/bin/activate" >> $(ACTIVATE)


clean:
	#
	#
	# --- REMOVE VIRTUAL ENVIRONMENT ---
	#
	rm -rf $(VENV)
	rm -f $(ACTIVATE)


update:
	#
	#
	# --- INSTALL PYTHON REQUIREMENTS ---
	#
	$(PIP) install -r $(REQUIREMENTS-PY) 


freeze:
	#
	#
	# --- LIST INSTALLED PYTHON PACKAGES ---
	#
	$(PIP) freeze


preview:
	#
	#
	# --- PREVIEW README IN BROWSER ---
	#
	nohup $(PY) -m grip README.md > /dev/null 2>&1 &
	$(BROWSER) "http://localhost:6419/" 


kill:
	#
	#
	# --- KILL ALL PYTHON PROCESSES IN THE VENV ---
	#
	killall $(PY)


# --- JUPYTERLAB ---

BROWSER := $(shell echo "$$BROWSER")

lab:
	#
	#
	# --- START JUPYTERLAB IN CHROMIUM ---
	#
	# TODO: Add conditional for verbose or quiet.
	# $(PY) -m jupyterlab --browser $(BROWSER) 
	nohup $(PY) -m jupyterlab --browser $(BROWSER) > /dev/null 2>&1 &


html:
	#
	#
	# --- CONVERT NOTEBOOK TO HTML ---
	#
	$(PY) -m jupyter nbconvert --execute --to html tutorium.ipynb
	$(BROWSER) tutorium.html


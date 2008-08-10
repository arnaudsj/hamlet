EBIN_DIR=ebin
SOURCE_DIR=src
INCLUDE_DIR=include
DOC_DIR=doc

ERLC_FLAGS=-W0 -Ddebug +debug_info
ERLC=erlc -I $(INCLUDE_DIR) -o $(EBIN_DIR) $(ERLC_FLAGS) $(SOURCE_DIR)
ERL=erl -I -pa ebin -noshell -eval

PARSER_BASE_NAME=hamlet
LEXER_NAME=$(PARSER_BASE_NAME)_lexer
PARSER_NAME=$(PARSER_BASE_NAME)_parser

all: compile docs

compile:
	mkdir -p $(EBIN_DIR)
	
	# Generate the lexer
	$(ERL) 'leex:file("$(SOURCE_DIR)/$(LEXER_NAME)",[{outdir,"$(SOURCE_DIR)"}]), halt().'
	
	# Generate the parser
	$(ERL) 'yecc:file("$(SOURCE_DIR)/$(PARSER_NAME)"), halt().'

	# Compile everything
	$(ERLC)/*.erl	

docs:
	$(ERL) -noshell -run edoc file $(SOURCE_DIR)/hamlet.erl -run init stop
	$(ERL) -noshell -run edoc_run application "'Hamlet'" '"."' '[no_packages]'
	mv $(SOURCE_DIR)/*.html $(DOC_DIR)/

clean:
	rm -rf erl_crash.dump 
	rm -rf $(EBIN_DIR)/*.beam
	rm -rf $(DOC_DIR)/*.html
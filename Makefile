ERL=erl
BEAMDIR=./deps/*/ebin ./ebin
REBAR=./rebar
NAME=eredis_pool
PLT_NAME=$(NAME).plt

all: clean get-deps update-deps compile xref

update-deps:
	@$(REBAR) update-deps

get-deps:
	@$(REBAR) get-deps

compile:
	@$(REBAR) compile

xref:
	@$(REBAR) xref skip_deps=true

clean: 
	@ $(REBAR) clean

eunit:
	@rm -rf .eunit
	@mkdir -p .eunit
	@ERL_FLAGS="-config test.config" $(REBAR) skip_deps=true eunit 

test: eunit

edoc:
	@$(REBAR) skip_deps=true doc


$(PLT_NAME): deps
	dialyzer --build_plt -r deps --apps erts kernel stdlib crypto mnesia sasl common_test eunit --output_plt $(PLT_NAME)

dialyze: compile $(PLT_NAME)
	dialyzer --check_plt --plt $(PLT_NAME) -c .
	dialyzer -c ebin

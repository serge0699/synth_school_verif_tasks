ITERS := 100

all:
	@make -C ../ EXAMPLE=11_comp -s clean
	@time make -C ../ EXAMPLE=11_comp -s COMP_OPTS=+define+URANDOM SIM_OPTS="-c +iters=$(ITERS)"
	@make -C ../ EXAMPLE=11_comp -s clean
	@time make -C ../ EXAMPLE=11_comp -s SIM_OPTS="-c +iters=$(ITERS)"

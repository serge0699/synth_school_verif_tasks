ITERS := 100

all:
	cd ../ && make EXAMPLE=13_comp clean
	cd ../ && make EXAMPLE=13_comp v="time " COMP_OPTS=+define+URANDOM SIM_OPTS=+iters=$(ITERS)
	cd ../ && make EXAMPLE=13_comp clean
	cd ../ && make EXAMPLE=13_comp v="time " SIM_OPTS=+iters=$(ITERS)
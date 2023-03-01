version=magiwanders/constellation:0.3

all:
	docker image build -t $(version) .
	
container: 
	docker container create -it --mount type=bind,source='$(shell pwd)'/renders,target=/home/renders --name constellation $(version) bash
	docker container ls -a

start:
	docker container start -i constellation

test:
	docker container start constellation
	docker exec constellation bash -c "cd /home/chipyard/sims/verilator && \
		source /home/conda/etc/profile.d/conda.sh && \
    	source /home/chipyard/env.sh && \
		make SUB_PROJECT=constellation BINARY=none CONFIG=$(name) run-binary-debug && \
		cd /home/chipyard/generators/constellation/scripts && \
		sed \"s/plt.show()/plt.savefig('\/home\/renders\/$(name)_render.png\')/\" vis.py > vis.txt && \
		cp vis.txt vis.py && \
		python vis.py /home/chipyard/sims/verilator/generated-src/constellation.test.TestHarness.$(name)/constellation.test.TestHarness.$(name).test.noc. && \
		sed \"s/plt.savefig('\/home\/renders\/$(name)_render.png')/plt.show()/\" vis.py > vis.txt && \
		cp vis.txt vis.py" 
	docker container stop constellation
	docker container start -i constellation

clean:
	docker container stop constellation
	docker container rm constellation
	docker container ls -a

uninstall:
	docker container rm constellation
	docker image rm $(version)
	

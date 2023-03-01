# constellation (Dockerfile)
Dockerfile for the [Constellation RTL NoC generator framework docker image](https://hub.docker.com/r/magiwanders/constellation).

Build:
```docker image build -t magiwanders/constellation:<version> .```

Run:
```docker container run --rm -it --name constellation magiwanders/constellation:<version> bash ```

In order to retrieve the visualization:
- Container: 
```
conda install networkx matplotlib
source /home/chipyard/env.sh 
cd /home/chipyard/generators/constellation/scripts 
sed 's/plt.show()/plt.savefig("noc_visualization.png")/' vis.py > vis.txt 
cp vis.txt vis.py 
python vis.py /home/chipyard/sims/verilator/generated-src/constellation.test.TestHarness.TestConfig00/constellation.test.TestHarness.TestConfig00.test.noc. 

```
- Host (with container running in the background):
```
docker cp constellation:/home/chipyard/generators/constellation/scripts/noc_visualization.png .
```

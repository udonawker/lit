[PlantUMLをUbuntuにインストールする](https://blog.katsubemakito.net/articles/install_plantuml_for_ubuntu)<br/>
[Ubuntu 18.04: UMLツールのPlantUMLをインストールする](https://www.hiroom2.com/2018/07/02/ubuntu-1804-plantuml-ja/)<br/>

<pre>
#!/bin/sh -e


sudo apt install -y graphviz default-jre

sudo mkdir -p /opt/plantuml
cd /opt/plantuml
UML=http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
sudo curl -JLO ${UML}

cat &lt;&lt;EOF | sudo tee /usr/local/bin/plantuml
#!/bin/sh

java -jar /opt/plantuml/plantuml.jar "\$@"
EOF
sudo chmod a+x /usr/local/bin/plantuml
</pre>

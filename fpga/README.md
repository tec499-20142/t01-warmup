Diretório de arquivos FPGA
==========================
Utilize este diretório para armazenar apenas arquivos relacionados com o projeto do circuito em FPGA. Por exemplo, memórias específicas para cada dispositivo, mapas de pinos, arquivos de inicialização e scripts de síntese.

Trabalhando com vários dispositivos
-----------------------------------
Em um projeto FPGA, o projetista pode se deparar com mais de um alvo de síntese. Sugere-se que sejam criados subdiretórios específicos para cada um deles. Por exemplo, se você pretende sintetizar e prototipar o seu IP no kit DE2-115 e uma placa dotada de um chip Cyclone III, utilize a organização a seguir.

- fpga/de2-115
- fpga/kit-cyc3

A quantidade não é limitada e você poderá trabalhar com quantos dispositivos desejar, mantendo a organização do repositório. Caso o alvo seja o mesmo, este nível de organização não se aplica, porém ainda é recomendado.

Subdiretório de Síntese
-----------------------------
Considerando os subdiretório específico para cada dispositivo de síntese, descritos acima, é preciso ainda organizar os diferentes tipos de elementos para evitar ambiguidades e favorecer o desenvolvimento ágil. 

Ao sintetizar um IP para um dispositivo específico, a ferramenta produz uma série de arquivos importantes para toda equipe envolvida no desenvolvimento do protótipo. Todavia, também são produzidos arquivos temporários, que são desnecessários para a distribuição e o compartilhamento entre os membros do time. Primeiramente, arquivos relacionados a síntese do IP devem ser armazenados em um diretório específicos, como segue abaixo.

-fpga/kit-cyc3/syn

São extensões válidas para arquivos de síntese:

ALTERA Quartus II
*****************
- *.qpf: arquivo que armazena as informações de projeto;
- *.qsf: arquivo que contém as atribuições de pinos, dispositivos e arquivos fonte do projeto;
- *.qdf: o mesmo que o .qsf, porém sua estrutura não é alterada com variações no projeto;
- *.sdc: arquivo de extensão chamado Synopsys Design Constraints, contendo informações de clock e restrições de temporização do circuito, utilizado em aplicaṍes específicas;
- *.sta: arquivos contendo este padrão contém informações do relatório de síntese no quesito power e timing;
- *.fit: arquivos contendo este padrão contém informações do relatório de síntese no quesito fiting;
- *.map: arquivos contendo este padrão contém informações do relatório de síntese no quesito mapping;
- *.pin: relatório de uso da pinagem do dispositivo FPGA (não é utilizado como entrada da ferramenta);

Os demais arquivos podem ser ignorados no controle de versão.

Subdiretório de Códigos RTL
---------------------------
Muitas vezes, ao projetar um circuito, fazemos uso de megafunções ou de modelos de síntese providos pelos fabricantes, ou desenvolvidos específicamente para o chip que compõe um kit de desenvolvimento. Sob esta perspectiva, recomenda-se a criação de um subdiretório para armazenar estes elementos como segue abaixo.

- fpga/kit-cyc3/rtl


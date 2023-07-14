# Documentation scripts

All the following commands should be run from Documentation/Scripts inside the *FeynCalc* directory

* To check for FeynHelpers symbols that are not properly documented, use 

    ```
    export MAKE_DOCU_LOAD_ADDONS="{FeynHelpers}"; export DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; export DOCU_INDEX_FILE=$DOCU_SOURCE_DIR/Markdown/Extra/FeynHelpers.md; ./checkMissingDocu.sh math
    ```
* To check for poorly formatted documentation files use

    ```
    export DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; ./checkQuality.sh
    ```

* To synchronize the usage information strings of FeynHelpers symbols with the documentation files use

    ```
    export MAKE_DOCU_LOAD_ADDONS="{FeynHelpers}"; export DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; ./updateUsageInformation.sh math
    ```

* To generate Markdown documentation from .m-files use

    ```
    export MAKE_DOCU_LOAD_ADDONS="{FeynHelpers}"; DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; ./exportToMD.sh math "$DOCU_SOURCE_DIR"/Markdown
    ```
    
* To update the HTML documentation use

    ```
    export DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; ./generateHTML.sh /media/Data/Projects/VS/feyncalc.github.io/FeynHelpersBookDev
    ```
    
* To update the TeX documentation use

    ```
    export DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; export DOCU_MANUAL_NAME="FeynHelpersManual"; export DOCU_INDEX_FILE=$DOCU_SOURCE_DIR/Markdown/Extra/FeynHelpers.md; ./generateTeX.sh /media/Data/Projects/VS/feynhelpers-manual/
    ```        
    
* To build the TeX documentation use

    ```
    latexmk -cd /media/Data/Projects/VS/feynhelpers-manual/FeynHelpersManual.tex -pdf
    ```

    Notice that when there are new figures (svg files), one would need to run

    ```
    export DOCU_SOURCE_DIR="/media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation"; ./svgToPdf.sh /media/Data/Projects/VS/fenyhelpers-manual/img/
    cp -n $DOCU_SOURCE_DIR/Markdown/img/*.pdf /media/Data/Projects/VS/feynhelpers-manual/img/
    ```

* To check Markdown files using mdl (`gem install mdl`, cf. [GitHub repo](https://github.com/markdownlint/markdownlint))

    ```
    mdl -r ~MD009,~MD013,~MD002,~MD010,~MD047,~MD024 /media/Data/Projects/VS/FeynCalc/FeynCalc/AddOns/FeynHelpers/Documentation/Markdown
    ```

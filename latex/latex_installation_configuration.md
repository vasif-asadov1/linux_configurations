# Download TEXLIVE2026 iso

From the following link download the iso file: 

[TEXLIVE2026.iso download link](https://mirrors.ctan.org/systems/texlive/Images/texlive2026.iso) 

Then, create specified directory and mount iso file using the following command: 

```bash 
sudo mkdir -p /mnt/texlive
sudo mount -o loop ~/Downloads/texlive2026.iso /mnt/texlive
```


It will warn you. It is normal. Then start installationn from the mounted device:

```bash
sudo /mnt/texlive/install-tl
```

The dialog will appear. Choose `I (Installation)` from there and it will install more than 4990 files. After the installation is completed, execute the following commands: 

```bash
fish_add_path /usr/local/texlive/2026/bin/x86_64-linux
echo 'set -gx MANPATH /usr/local/texlive/2026/texmf-dist/doc/man $MANPATH' >> ~/.config/fish/config.fish
echo 'set -gx INFOPATH /usr/local/texlive/2026/texmf-dist/doc/info $INFOPATH' >> ~/.config/fish/config.fish
```

- I am using FISH shell.

After these steps, check the installation: 

```bash
tex --version
```

If everhything is okay, then unmount the iso device: 

```bash
sudo umount /mnt/texlive
```



# Configuring TEX-STUDIO

In order to run the `.tex` files succesfully, I implemented the following steps. I aimed to store auxiliary files into the `buil` folder inside the main project directory and keeping pdf and original tex file in the main directory. Apply the following steps to configure your TEX-STUDIO in that way: 


1. Click to `Options -> Configure TeXStudio`
2. In the `Commands` section for pdflatex, xelatex and lualatex write the following commands, respectively.

    - `pdflatex -synctex=1 -interaction=nonstopmode -shell-escape -output-directory=build %.tex`
    - `xelatex -synctex=1 -interaction=nonstopmode -shell-escape -output-directory=build %.tex`
    - `lualatex -synctex=1 -interaction=nonstopmode -shell-escape -output-directory=build %.tex`
    
3. In the same `Commands` section, search for Bibtex and Biber, and replace the commands with the followings, respectively:

    - `bibtex build/%`
    - `biber --output-directory build %`
    
4. Click to the `Build` button in the sidebar and in the Meta Commands section, write the following command:

    - Default Compiler: `txs:///createdir | txs:///pdflatex | txs:///copypdf`

5. In the User Commands section, click to `Add` button and adjust these commands:

    - createdir: `mkdir -p build`
    - copypdf: `cp build/%.pdf build/%.synctex.gz ./`
    
6. Finally, in the Build Options section, adjust the following: 
    - Log File: `build`
    - Commands ($PATH): `/usr/local/texlive/2026/bin/x86_64-linux:/usr/bin:/usr/local/bin`



# Configuring Visual Studio Code 

In the VS Code, install **Latex Workshop** extension. Then click to Ctrl+Shift+P and write `Preferences: Open User Settings (JSON)`. Then paste the following configuration to the end of JSON scrpt. 


```json
    // ─── LATEX ────────────────────────────────────────────────────
    "[latex]": {
        "editor.fontFamily": "'Noto Serif', Georgia, serif",
        "editor.fontSize": 15,
        "editor.lineHeight": 1.9,
        "editor.wordWrap": "wordWrapColumn",
        "editor.wordWrapColumn": 70,
        "editor.wrappingIndent": "none",
        "editor.tabSize": 4,
        "editor.insertSpaces": true,
        "editor.detectIndentation": false,
        "editor.inlineSuggest.enabled": true,
        "editor.quickSuggestions": {
            "other": "on",
            "comments": "on",
            "strings": "on"
        }
    }
```

Note: If there are other preferences, then put comma before our LaTeX regulation script.

































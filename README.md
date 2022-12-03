### terraform-cloud-scripts

This project lets you configure `Terraform Cloud` with `API`

### Installation

##### MacOS
```
git clone https://github.com/dasmeta/terraform-cloud-scripts.git

cd terraform-cloud-scripts

for file in *.sh; do  mv -- "$file" "${file%.sh}"; done

cp -r ./ ~/.tf-scripts

echo "export PATH=$PATH:~/.tf-scripts" >> ~/.zshrc

su $USER

```

##### Linux / Unix-like
```
git clone https://github.com/dasmeta/terraform-cloud-scripts.git

for file in *.sh; do  mv -- "$file" "${file%.sh}"; done

cp -r ./ ~/.tf-scripts

echo "export PATH=$PATH:~/.tf-scripts" >> ~/.bashrc

su $USER
```
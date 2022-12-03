### terraform-cloud-scripts

This project lets you configure `Terraform Cloud` with `API`

### Installation

##### MacOS
```
git clone https://github.com/dasmeta/terraform-cloud-scripts.git

for file in *.sh; do  mv -- "$file" "${file%.sh}"; done

cp -r ./terraform-cloud-scripts ~/.tf-scripts

echo "export PATH=$PATH:~/.tf-scripts" >> ~/.zshrc

```

##### Linux / Unix-like
```
git clone https://github.com/dasmeta/terraform-cloud-scripts.git

for file in *.sh; do  mv -- "$file" "${file%.sh}"; done

cp -r ./terraform-cloud-scripts ~/.tf-scripts

echo "export PATH=$PATH:~/.tf-scripts" >> ~/.bashrc
```
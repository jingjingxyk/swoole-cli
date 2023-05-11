let extension_list = async() => {
    let response = await fetch('http://192.168.3.26:9502/api/extensionList')
    let res = await response.json();
    if (response.status === 200 && res) {
        let extension_list = document.querySelector('ul[name="all_extentions"]')
        if (extension_list) {
            let children = '  '
            let patt =/\.php$/
            res['data'].map((value, index, array) => {
                value=value.replace(patt,"")
                value=value.trim()
                children += `
                    <li value="${value}">${value}</li>
                `
            });

            extension_list.innerHTML = children;
        }
    }
    default_ready_extension_list();
}
let default_ready_extension_list = async()=>{

    let response = await fetch('http://192.168.3.26:9502/api/defaultExtensionList')
    let res = await response.json();
    if (response.status === 200 && res && res['data']) {
        let extension_list = document.querySelector('ul[name="ready_extentions"]')
        if (extension_list) {
            let children = '  '
            res['data'].map((value, index, array) => {
                let ele=document.querySelector(`ul[name="all_extentions"] li[value="${value}"]`)
                ele.classList.add('ready_extension')

                children += `
                    <li value="${value}" class="ready_extension">${value}</li>
                `
            });

            extension_list.innerHTML = children;
        }
    }
    let submmit_btn=document.querySelector('.exec-button')
    if(submmit_btn){
        submmit_btn.addEventListener('click',exec)
    }
}

let exec=(e)=>{

    let os=document.querySelector('select[name="os"]')
    let with_docker =document.querySelector('select[name="without-docker"]')
    let skip_download =document.querySelector('select[name="skip-download"]')
    let with_download_mirror_url =document.querySelector('select[name="with-download-mirror-url"]')
    let with_dependecny_graph=document.querySelector('select[name="with-dependency-graph"]')

        console.log(os.value)
        console.log(with_docker.value)
        console.log(skip_download.value)
        console.log(with_download_mirror_url.value)
        console.log(with_dependecny_graph.value)

}
export {extension_list}

# What is Docker

大鯨魚 - 裡面有輕量版的OS，因此run一個docker container就是跑起來一個作業系統，從此以後輕易跨平台了

重要名詞 : 

## Docker Architecture

1. Docker daemon - 兼通Docker API request並管理docker物件(如images, containers, networkds, volumes, 並且可以和其他docker daemon溝通)
2. Docker client - docker使用者與docker程式互動的地方，例如執行`docker run`就是送一個指令到`docker daemon (dockerd)`
3. Docker registries - 儲存docker images的地方，例如Docker Hub就是一個公開的docker註冊表，你也可以創建和管理一個自己的註冊表

## Docker objects

1. images - 唯讀物件，裡面寫著如何建造docker container的指示(就像是說明書)，通常情況下一張image會基於其他張image，但是加入一些客製化內容，例如我們可以建立一張image基於ubnutu，但是加裝Apache web server。

你可以寫一個Dockerfile並使用docker API / docker CLI來創建docker image。

2. containers - image所創造出來的物件，你可以透過docker API或是docker CLI創建，開始，停止，移動，或是刪除container。並且可以經由一個或是多個網路連接container，或是附帶它(attach)，甚至是按照此container建立一張新的image

3. container在你創造或是開始時就定義了他的組態，例如網路參數或是如何附帶，當container被刪除後，該container的參數隨之消失

## Docker services

Services讓你可以在多個docker demon之間規模化的使用container，這個場景下或有三個角色，swarm，managers，workers，每個swarm的member就是一個daemon，而這些daemon經由Docker API進行溝通，在預設的情況下，service在多個worker nodes是load-balanced的。

## Dockerfile

* 將docker container建立起來的config檔案，告訴任一個裝有docker的電腦說，你要從docker hub抓什麼下來，加裝什麼，在作業系統裡面要下載哪些(wget, git, apt-get install, ...)
* 常見變數(其他的可以在官網上查到)
  + `WORKDIR` - docker coantainer內的目前路徑
  + `RUN` - docker container中的bash執行的指令
  + `EXPOSE` - docker container中要開放的port
  + `FROM` - 從docker hub中取一個Dockerfile作為base
  + `COPY` - 從local machine copy任意檔案到container的路徑
  + `ENTRYPOINT`

    - - `["excutable", "param1", "param2"]` 在container中執行，例如`["top", "-b"]`
    - - `excutable param1 param 2` (shell style)
  + `CMD`
    - `["excutable", "param1", "param2"]`，和`ENTRYPOINT`的做法相同
    - `["param1", "param2"]` - `ENTRYPOINT`為預設的執行程式
    - `command param1 param2` - shell style - 例如`CMD echo "This is a cat" | wc -`

* 常見操作
  + `docker build` - 輸入Dockerfile，將其建立成一張docker image

## Docker image

* 一包可以被跑起來的檔案，輸入`docker run image name`就可以跑起來一個docker container，即一個完全獨立的服務

* 常見操作
  + `docker run -e[environment variables] -a[attatch stdin, stdout] -c[cpu sharing resource]-h[hostname stuff] -i[interactive, ip string], -m[memory usage] -p[port stuff], ...`

## Trouble Shooting

Q1 : Docker如果要取用GPU資源，要怎麼和GPU進行溝通!? 

A1 : NVIDIA提供了溝通程式，稱作nvidia-docker2

  + [Official documentation](https://github.com/NVIDIA/nvidia-docker?fbclid=IwAR3ncStZvKKSht6UGYwFU7hOI0Q4l_czFPufJYw7_uJ5p2R0vsF8b0zmiaA)
  + [Non Official introduction 1](https://ithelp.ithome.com.tw/articles/10205391?sc=iThelpR&fbclid=IwAR1cL21cPRUmSXHS0URKVSS8KnhN4c4iaVC7NtMsu3Y5IQ6g_Q8ZXav6MSw)
  + [Non Official introduction 2](https://medium.com/@abose550/deep-learning-for-production-deploying-yolo-using-docker-2c32bb50e8d6?fbclid=IwAR1kZMo00OhRvvoOmsY9YARX722_4J1srmkY-LuR8NGMYPuQ84M0ZMxzlCs)

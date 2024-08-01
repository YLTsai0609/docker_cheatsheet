# What is Docker

大鯨魚 - 裡面有輕量版的OS，因此run一個docker container就是跑起來一個作業系統，從此以後輕易跨平台了

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
* 常見變數
  + `WORKDIR` - docker coantainer內的目前路徑
  + `RUN` - docker container中的bash執行的指令
  + `EXPOSE` - docker container中要開放的port
  + `FROM` - 從docker hub中取一個Dockerfile作為base
  + `COPY` - 從local machine copy任意檔案到container的路徑
  + `ENTRYPOINT`

    - `["excutable", "param1", "param2"]` 在container中執行，例如`["top", "-b"]`
    - `excutable param1 param 2` (shell style)
  + `CMD`
    - `["excutable", "param1", "param2"]`，和`ENTRYPOINT`的做法相同
    - `["param1", "param2"]` - `ENTRYPOINT`為預設的執行程式
    - `command param1 param2` - shell style - 例如`CMD echo "This is a cat" | wc - l`

* 常見操作
  + `docker build --tag image_name` - 輸入Dockerfile，將其建立成一張docker image，並給定image name

## Docker image

* 一包可以被跑起來的檔案，輸入`docker run image name`就可以跑起來一個docker container，即一個完全獨立的服務

* 常見操作
  + `docker run -e[environment variables] -a[attatch stdin, stdout] -c[cpu sharing resource]-h[hostname stuff] -i[interactive, ip string], -m[memory usage] -p[port stuff], ...`

## Volume

讓Container內的資料可以和本地端的檔案系統互通的一種方式
先create在使用的稱作 `name volume` ，直接run起來接著的稱作 `host volume` ，透過volume，可以讓不同的container丟檔案到本地檔案系統，並且之後給另外的container使用

## Resource Status

[找回那些被 Docker 吃掉的磁碟空間](https://medium.com/starbugs/%E6%89%BE%E5%9B%9E%E9%82%A3%E4%BA%9B%E8%A2%AB-docker-%E5%90%83%E6%8E%89%E7%9A%84%E7%A3%81%E7%A2%9F%E7%A9%BA%E9%96%93-6912cdb24dc0)

Docker Image, Container, Volume, Network 都稱做 docker resource， resource 有所謂的狀態


used : 正在被 container 使用
ununsed : 完全沒有被 container 使用到
dangling : 失效的 image，永遠不會被使用

used <--> ununsed : 至少被一個 Container 使用

dangling : 只存在在 images
* 當我們重複編譯同一個 tag name 的 docker image，那麼第一次產生的 docker image 在第二次編譯結束時就會進入 dangling 狀態
* 常發生的就是 cache，可能是因為 build failed 或其他原因產生

## Docker is not exactly cross-platform

雖然 Docker 的設計理念是為了實現跨平台兼容，但在實際應用中，跨平台構建 Docker 映像時仍然可能遇到問題。這些問題通常與不同主機系統的底層依賴性、硬體架構、以及特定工具或庫的兼容性有關。以下是一些原因、示例，以及社群中討論過的重要事件：

原因

	1.	硬體架構差異：
	•	Docker 映像通常是在特定硬體架構上構建的，例如 x86_64 或 ARM。如果你在不同架構的主機上運行相同的 Dockerfile，可能會出現兼容性問題，尤其是當映像包含與硬體架構相關的編譯代碼時。
	2.	底層系統依賴：
	•	某些應用程序依賴於主機的內核特性或特定的系統庫。如果 Dockerfile 中包含的軟件依賴於這些特性，而在其他平台上不完全支持，則可能導致構建或運行失敗。
	3.	不同平台上的工具兼容性：
	•	某些工具或軟件包可能會根據主機的操作系統和版本表現出不同的行為。特別是在一些需要安裝編譯工具或依賴包的 Dockerfile 中，這種問題更為普遍。

示例

	1.	x86_64 與 ARM 架構的差異：
	•	假設你在 x86_64 上構建了一個 Docker 映像，並使用了與架構相關的二進制文件或工具。在 ARM 平台（如 Raspberry Pi）上嘗試運行該映像可能會失敗，因為二進制文件並不兼容。
	2.	不同 Linux 發行版的依賴性：
	•	例如，在一個 Ubuntu 基礎的 Dockerfile 中使用 apt-get 安裝的某些包，可能無法在使用 Alpine Linux 的 Dockerfile 中正確構建。這是因為不同 Linux 發行版使用不同的包管理器和庫版本。
	3.	MacOS 與 Linux 的兼容性問題：
	•	Docker 在 MacOS 上運行時，實際上是通過一個虛擬化層運行 Linux 容器。有些應用程序可能需要直接訪問 Linux 內核特性，這些特性在 MacOS 上可能表現出不同的行為或根本不可用。

社群中的重大事件

	1.	Apple M1 芯片支持問題：
	•	當 Apple 在 2020 年推出基於 ARM 架構的 M1 芯片後，許多基於 x86_64 構建的 Docker 映像無法在新硬體上直接運行，導致大量開發者和社群討論如何跨平台構建兼容性更好的映像。Docker 隨後推出了針對 M1 的更新，但這個過程中揭示了跨架構構建的挑戰。
	2.	多平台 Docker 映像構建工具的興起：
	•	由於上述問題，Docker 社群中多平台構建工具的需求增加。Docker 官方推出了 buildx 插件，支持多架構構建，但這仍需要開發者明確考慮並處理各種平台的依賴差異。

結論

Docker 確實提供了一個強大的跨平台工具，但在不同平台間構建 Dockerfile 時仍然可能遇到挑戰。這些挑戰通常來自硬體架構差異、底層系統依賴，以及特定工具或庫的兼容性問題。社群中對這些問題的討論和解決方案反映了跨平台構建仍是一個需要持續解決的現實問題。

## 什麼是底層架構，跟作業系統之間的關係又是什麼

### 常見作業系統與對應底層架構

以下是常見作業系統及其對應的底層硬體架構：

1. Ubuntu

	•	底層架構：通常支援多種架構，包括：
	•	x86_64 (AMD64)：64-bit 架構，適用於大多數桌面和伺服器。
	•	ARM：如 ARMv7 和 ARMv8，適用於某些嵌入式裝置和 Raspberry Pi。

2. Linux

	•	底層架構：Linux 是一個內核，支援多種架構，包括：
	•	x86_64 (AMD64)：64-bit 架構，適用於桌面和伺服器。
	•	ARM：包括 ARMv7、ARMv8，適用於嵌入式系統和某些伺服器。
	•	i386 (x86)：32-bit 架構，較少見，但仍被支援。
	•	RISC-V、MIPS、PowerPC 等：其他架構也受到支持。

3. CentOS

	•	底層架構：
	•	x86_64 (AMD64)：主要用於伺服器和桌面系統。
	•	ARM：某些版本和分支支援 ARM 架構，但相對較少見。

4. MacOS

	•	底層架構：
	•	x86_64 (AMD64)：對於使用 Intel 處理器的 Mac 系統。
	•	ARM（Apple Silicon/M1、M2）：對於 Apple M1 和 M2 系列的 ARM 架構處理器。

5. Windows

	•	底層架構：
	•	x86_64 (AMD64)：主要用於桌面和伺服器系統。
	•	ARM：支持於 Windows 10 和 Windows 11 的 ARM 版本，主要用於某些輕薄型設備和 ARM 平板電腦。

6. Raspberry Pi

	•	底層架構：
	•	ARM：主要是 ARMv6 和 ARMv7（例如 Raspberry Pi 1 和 Raspberry Pi 2）以及 ARMv8（例如 Raspberry Pi 3 和 Raspberry Pi 4）。Raspberry Pi 使用的 ARM 架構處理器，適合嵌入式和教育用途。

總結

	•	x86_64 (AMD64)：常見於桌面和伺服器系統，支援 Ubuntu、CentOS、Windows、部分 MacOS 版本等。
	•	ARM：主要用於嵌入式系統和一些輕薄型設備，支援 Ubuntu、Linux、CentOS（某些版本）、MacOS（Apple Silicon）、Raspberry Pi 等。
	•	i386 (x86)：主要用於舊式桌面系統，現在較少見。
	•	其他架構（如 RISC-V、MIPS、PowerPC）：用於特定的嵌入式系統或特殊用途。

這些作業系統和硬體架構的對應關係反映了它們在不同領域中的應用和支援範圍。

### 硬體架構 (ISA) 的差異和選擇

底層架構（或硬體架構）是指計算機硬體的設計和組織方式，它決定了處理器的功能、性能以及指令集結構（Instruction Set Architecture, ISA）。不同的底層架構會影響作業系統、應用程序的執行和性能。以下是一些常見的底層架構及其特點：

常見底層架構介紹

	1.	x86_64 (AMD64)
	•	描述：這是 64 位元的 x86 架構，由 AMD 提出的 AMD64 擴展。它是 x86 架構的擴展，支援更大的記憶體地址空間和更多的寄存器。
	•	用途：廣泛應用於桌面電腦、伺服器和工作站。
	•	指令集：支援 x86 指令集，增強了 64 位元運算的能力。
	•	例子：大多數現代桌面電腦和伺服器使用 x86_64 架構，運行 Windows、Ubuntu、CentOS 等作業系統。
	2.	ARM (Advanced RISC Machine)
	•	描述：ARM 是一種精簡指令集計算（RISC）架構，設計上強調低功耗和高效能，適用於嵌入式系統。
	•	用途：廣泛應用於手機、平板電腦、嵌入式設備、IoT 裝置、部分伺服器（如 ARM 伺服器）等。
	•	指令集：RISC 指令集，具有簡化的指令集和高效的執行效率。
	•	例子：Raspberry Pi 使用 ARM 架構，Mac 的 Apple Silicon（如 M1 和 M2 處理器）也是基於 ARM 架構。
	3.	i386 (x86)
	•	描述：這是早期的 32 位元 x86 架構，支援 32 位元運算。雖然現代處理器大多已轉向 x86_64，但 i386 仍在一些舊系統中使用。
	•	用途：早期的桌面電腦和伺服器。
	•	指令集：支援 32 位元的 x86 指令集。
	•	例子：較舊的桌面電腦和伺服器，運行舊版的 Windows、Linux 系統。
	4.	RISC-V
	•	描述：一種開放源碼的 RISC 指令集架構，旨在提供高度的靈活性和擴展性。
	•	用途：嵌入式系統、學術研究和一些特定的商業應用。
	•	指令集：開放的 RISC 指令集，支持多種擴展。
	•	例子：尚在發展中，逐步進入一些新興市場和開發板。
	5.	MIPS (Microprocessor without Interlocked Pipeline Stages)
	•	描述：一種 RISC 架構，廣泛應用於嵌入式系統和學術研究。
	•	用途：嵌入式系統、網絡設備、學術研究。
	•	指令集：RISC 指令集，專注於簡單的指令和高效的執行。
	•	例子：一些早期的路由器和嵌入式系統使用 MIPS 架構。
	6.	PowerPC
	•	描述：由 IBM、摩托羅拉和其他公司合作開發的 RISC 架構，主要用於工作站和伺服器。
	•	用途：曾經用於一些高性能工作站和伺服器，現在主要用於嵌入式系統。
	•	指令集：RISC 指令集，設計上重視高效能。
	•	例子：早期的 Apple Macintosh 電腦、一些嵌入式系統和伺服器。

不同作業系統為何選擇不同架構

	1.	性能需求：
	•	作業系統會根據目標硬體的性能需求選擇適合的架構。例如，伺服器和高性能工作站通常使用 x86_64 架構，因為它能夠提供高效能和較大的記憶體地址空間。
	2.	功耗和效能考量：
	•	對於移動設備和嵌入式系統，ARM 架構因其低功耗和高效能而受到青睞。它非常適合需要長時間運行和高能效的應用。
	3.	開發和市場需求：
	•	某些作業系統選擇支援特定架構是因為市場需求或開發便利性。例如，Raspberry Pi 使用 ARM 架構，因為它廣泛應用於教育和低成本嵌入式設備。
	4.	專利和授權：
	•	一些架構如 ARM 是商業化的，作業系統可能因為授權成本和專利問題選擇其他架構。開放源碼架構如 RISC-V 則可以降低授權成本。
	5.	歷史和兼容性：
	•	某些作業系統選擇了特定架構以維持歷史兼容性。例如，早期的 Windows 和 Linux 系統在 x86 架構上有廣泛的使用，這影響了它們在後續版本中的選擇。

不同的作業系統根據它們的設計目標、性能需求、授權問題以及市場需求，選擇了適合的底層架構。這些選擇會影響系統的效率、兼容性以及最終的用戶體驗。

## Trouble Shooting

Q1 : Docker如果要取用GPU資源，要怎麼和GPU進行溝通!? 

A1 : NVIDIA提供了溝通程式，稱作nvidia-docker2

  + [Official documentation](https://github.com/NVIDIA/nvidia-docker?fbclid=IwAR3ncStZvKKSht6UGYwFU7hOI0Q4l_czFPufJYw7_uJ5p2R0vsF8b0zmiaA)
  + [Non Official introduction 1](https://ithelp.ithome.com.tw/articles/10205391?sc=iThelpR&fbclid=IwAR1cL21cPRUmSXHS0URKVSS8KnhN4c4iaVC7NtMsu3Y5IQ6g_Q8ZXav6MSw)
  + [Non Official introduction 2](https://medium.com/@abose550/deep-learning-for-production-deploying-yolo-using-docker-2c32bb50e8d6?fbclid=IwAR1kZMo00OhRvvoOmsY9YARX722_4J1srmkY-LuR8NGMYPuQ84M0ZMxzlCs)

A2 : (2020 Nov.)Windows兩種作法

  1. [用Windows的Base Image來Build](https://docs.microsoft.com/zh-tw/virtualization/windowscontainers/deploy-containers/gpu-acceleration)
  2. 將Windows升級到20150版本，安裝WSL 2，接著就像Ubuntu一樣安裝nvidia-docker2
  + 隨著時間的推移，可以參考[windows版本號Wiki](https://zh.wikipedia.org/wiki/Windows_10%E7%89%88%E6%9C%AC%E5%8E%86%E5%8F%B2)，目前(2020 Nov.)20150還是開發版(該版本是6月釋出)，帶該版本更穩定之後升級上去
  + [參考資料1 NVIDIA blog 微軟宣布WSL 2支援CUDA, GPU](https://developer.nvidia.com/blog/announcing-cuda-on-windows-subsystem-for-linux-2/)
  + [參考資料2 2020 6月的安裝實測](https://zhuanlan.zhihu.com/p/149517344)

Q2 : 如果私人的docker repo協作上有困難，有沒有直接傳輸docker image的方式?
A2 : 有，可以docker save, docker load，參考[這個回答](https://stackoverflow.com/questions/23935141/how-to-copy-docker-images-from-one-host-to-another-without-using-a-repository?fbclid=IwAR0XOeMKgWt8DP70rMZn7GCPWMibtoVTRbAqqsOjfmA1sn5K8VP5wGzFhsc)

Q3 : 如何使用別人private的image?
A3 : [官方文件有說明](https://docs.docker.com/engine/reference/commandline/login/)，透過docker login之後，該使用者repo的Key會放在

  + Linux : `$HOME/.docker/config.json`
  + Windows : `%USERPROFILE%/.docker/config.json`

分享我經驗上可行的docker學習路線:(教同事用的)

01. 先執行hello-world確定可以跑
02. 網路上面看一下簡單介紹docker系統架構的影片，主要是理解一下docker的image commit還有為何大家都用他。
03. 自己建一個bash指令的image，大概echo一下參數或者環境變數就行。
04. 弄個網頁伺服器(nginx之類的)，搭配volume(-v參數)把本機檔案丟到伺服器裡面，可以用瀏覽器打開看到內容，這個你需要export port (-p參數)。

    4-1. 利用volume修改網頁伺服器設定檔。

05. 撰寫 docker compose file。 (可選下面其中一個，寫法略有不同，而且build和deploy也不太一樣)

    5-1. docker compose 來用多個container互相合作。
    5-2. docker swarm init之後, 用docker stack 來串聯多個service互相合作。

06.  安裝docker管理gui，最簡單的推薦portainer。
07. 該來多機器串連了，前面選擇 5-2 的因為做過swarm init，所以只要下 docker swarm join-token worker產生給新機器加入這個swarm的指令，需要注意自動產生的指令IP通常為區網，跨網域的話請自己改成第一台機器(manager)的IP。(防火牆注意一下)
08.  嘗試部署多機器swarm環境的服務，會發現volume開始要設定deploy placement constraints條件才抓的到，透過network來有限的暴露服務port。

    8-1.更多問題... 比如說服務開太久如何自動重開，log怎麼保留還有限制資料上限。

09. 機器數量多到一定程度之後，開始做多swarm network規劃。
10. 機器更多/規模更大的時候...開始想轉到K8S，後面就不是docker問題了，再次上網詢問K8S的新手教學XD

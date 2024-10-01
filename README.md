# 遅刻リンピック

## 概要
遅刻リンピックは、遅刻に焦点を当てたイベント管理アプリです。  
イベントに参加したユーザがどれだけ遅刻したかをリアルタイム表示。  
ランキング機能や参加・不参加の追跡、プロフィール管理機能などを搭載しています。  

## 主な機能
1. ランキング機能  
ランキング表示: イベントごとに、ユーザーの遅刻距離（遅刻した時間や距離）を表示します。  
到着者一覧: イベントにすでに到着した人や、まだ到着していない人を確認できます。  
2. イベント詳細  
イベントの招集画面: イベントの開始時間、場所、参加費などの詳細を表示します。  
参加状況の確認: 参加者、未参加者のリストを表示し、誰がイベントに来るのか一目でわかります。  
3. プロフィール管理  
称号: 遅刻回数やその他の統計情報に基づいて、ユーザーは特定の称号を強制的に付与されます。  
遅刻統計: 各ユーザーの遅刻回数、間に合った回数、総遅刻時間を記録し、プロフィールページで確認可能。  

## アーキテクチャ：MVVM+MV
### 説明
基本的にはViewに対して単一のViewModelを作成しています。  
複数の画面で使用する必要のあるデータは@Environmentを活用しながらModelでデータを管理しています。
@Environmentを活用することで、離れた画面間でも簡単にデータの共有できるようになっています。  
具体的なMVパターン適応箇所としては、ユーザープロフィールデータの管理などが挙げられ、新規ユーザ作成画面とプロフィール画面でModelが共有されています。

## 使用技術

<img alt="使用技術" src="https://skillicons.dev/icons?theme=light&perline=8&i=swift,python,supabase,firebase" />


- モバイル -> **Swift SwiftUI UIKit Combine Alamofire**
- バックエンド -> **Python FastAPI WebSocket(導入中)**
- DB -> **Supabase**
- デプロイ -> **Render**
- 認証 -> **SupabaseAuth**
- 通知 -> **FirebaseCloudMessaging**





| ランキング画面 | イベント招集画面 | プロフィール画面 |
|:--------------:|:----------------:|:----------------:|
| <img src="https://github.com/user-attachments/assets/2e4f7d7f-45f1-475e-a9e8-9c905a5b0435" alt="Ranking Screen" width="300"> | <img src="https://github.com/user-attachments/assets/e3417269-d461-42b3-88ba-9a7b607a0ee0" alt="Event Invitation Screen" width="300"> | <img src="https://github.com/user-attachments/assets/24b7f241-42c0-4941-80bd-328d9ac99690" alt="Profile Screen" width="300"> |



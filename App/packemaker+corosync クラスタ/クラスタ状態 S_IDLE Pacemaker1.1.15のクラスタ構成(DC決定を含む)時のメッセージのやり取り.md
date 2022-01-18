## [Pacemaker1.1.15のクラスタ構成(DC決定を含む)時のメッセージのやり取り](https://qiita.com/HideoYamauchi/items/74e8c7dd52ff37998419)

## 利用されるタイマーについて
* election_triggerタイマー - electionを開始するかどうかDC探索の為のタイマー
* electionタイマー - DC決定の為のタイマー
* integrationタイマー - クラスタメンバー合意完了の為のタイマー
* finalization_timer - クラスタ構築完了の為のタイマー

## 開始(S_STARTING)
* 1. 初期起動関連処理を実行
* 2. election_triggerタイマー(dc_deadtime:デフォルト20s)を仕掛ける
	* 自ノードが既にDCの場合はI_ELECTIONへ

## DC探索(S_PENDING)
* 3. CRM_OP_JOIN_ANNOUNCEメッセージ送信(起動済みのDC探索)
* 4. 応答の有無によって処理が異なる
	* DCが存在しなければDCから応答がない場合は、election_triggerタイマーが発動し、5へ
	* DCが存在する場合は、DCノードがCRM_OP_JOIN_ANNOUNCEに応答して、CRM_OP_JOIN_OFFERメッセージを送ってきたノードへ返信し、7へ

## DC決定(S_ELECTION)
* 5. CRM_OP_VOTEメッセージ送信(S_ELECTIONへ)
* 6. election_timeoutタイマー(election_timeout:2min)を仕掛ける
	* election_timeoutタイマーは、crmdの状態遷移(do_state_transition()中にS_ELECTION、S_RELEASE_DC以外に遷移する場合に停止される。
* 6-1. CRM_OP_VOTEメッセージを受信
	* do_election_count_vote()処理を実施
	* votedハッシュテーブルには、DCになれそうなノードのみが積み上げを行う
		* DCになれないノードはここでCRM_OP_NOVOTEメッセージを送信
		* DCになれないノードは、election_timeoutタイマーもキャンセルする
		* DCになれそうなノードは、election_timeoutタイマーをキャンセルしないので、DCになれるならelection_timeoutタイマーが発動する
	* do_election_check()処理を実施 ---- election_timeoutタイマーが発動して処理が進み、構成メンバーの情報が揃った時にも処理
	* 構成予定メンバーでCRM_OP_VOTEメッセージのやり取りが終了し場合は(voteハッシュテーブルに構成予定メンバーの情報が揃った)、メンバーのcrmd宛てにCRM_OP_JOIN_OFFERメッセージを送信(DCノードからしか実行されない)
* 6-2. CRM_OP_NOVOTEメッセージを受信
	* メッセージのノード情報でvotedハッシュテーブルの更新を行う。

## クラスタメンバの合意(S_INTEGRATION)
* integration_timerタイマー(crmd-integration-timeout:デフォルト3min)は、crmdの状態遷移(do_state_transition)中にS_INTEGRATIONに遷移する場合に仕掛けられる。
* 7. CRM_OP_JOIN_OFFERメッセージを受信
	* DCをセットして、CRM_OP_JOIN_REQUESTをDCに送信
	* election_triggerタイマーを停止
* 8. CRM_OP_JOIN_REQUESTメッセージを受信
	* DCノードは構成予定メンバーからのCRM_OP_JOIN_REQUEST受信待ち状態
	* 受信完了後に、CRM_OP_JOIN_ACKNAKメッセージをメンバーに送信(CRMD_JOINSTATE_MEMBERならCRM_OP_JOIN_ACKNAKはTRUE,その他はFALSE)

## クラスタ構成の完了(S_FINALIZE_JOIN)
* integration_timerタイマーは、crmdの状態遷移(do_state_transition)中にS_INTEGRATION以外に遷移する場合に停止される。
* finalization_timerタイマー(crmd-finalization-timeout:デフォルト30min)は、crmdの状態遷移(do_state_transition)中にS_FINALIZE_JOINに遷移する場合に仕掛けられる。
* 9. CRM_OP_JOIN_ACKNAKメッセージ受信
	* DCをセット
	* CRM_OP_JOIN_CONFIRMメッセージをDCに送信
* 10. CRM_OP_JOIN_CONFIRMメッセージ受信
	* 構成予定メンバーでCRM_OP_JOIN_REQUESTメッセージ、CRM_OP_JOIN_CONFIRMメッセージのやり取りが終了し場合は、pengineへの状態遷移作成依頼
	* finalization_timerタイマーは、crmdの状態遷移(do_state_transition)中にS_FINALIZE_JOIN以外に遷移する場合に停止される。

## 状態遷移を計算(S_POLICY_ENGINE)
* 現在DCのCIBを元にして状態遷移を作成

## 状態遷移を実行(S_TRANSITION_ENGINE)
* 状態遷移を実行

## 安定状態(S_IDLE)
* 状態遷移実行完了後のクラスタ安定状態で、ノード故障、リソース故障などの要因がない場合には安定状態を続けます。


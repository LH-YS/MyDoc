#pragma once
class CNC
{
private:
	int who;
	int num;//CNC编号
	int state;//表示CNC的状态 0是空闲状态 1是工作状态 2是等待状态 3是被占用状态
	int work_time;//表示已工作时间
	int sleep_time;//表示睡眠时间
	int remaining_time;//剩余时间
	int knife;//刀片类型
public:
	int pos;//位置
	void create();
	int get_who();
	void change_who(int a);
	int get_num();
	void change_num(int a);
	int get_pos();
	int get_state();
	void change_state(int a);
	int get_work_time();
	void change_work_time(int a);
	int get_sleep_time();
	int get_remaining_time();
	void change_remaining_time(int a);
	void change_sleep_time(int a);
	int get_knife();
	CNC();
	~CNC();
};


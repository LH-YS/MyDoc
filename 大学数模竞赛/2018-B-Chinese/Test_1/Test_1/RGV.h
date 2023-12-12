#pragma once
class RGV
{
private:
	int state;//0是初始状态 1是休眠状态 2是上下料状态 3是移动状态
	int work_time;
	int move_time;
	int sleep_time;
	int remaining_time;
	int pos;
public:
	int get_state();
	void change_state(int a);
	int get_work_time();
	void change_work_time(int a);
	int get_move_time();
	void change_move_time(int a);
	int get_sleep_time();
	void change_sleep_time(int a);
	int get_remaining_time();
	void change_remaining_time(int a);
	int get_pos();
	void change_pos(int a);
	RGV();
	~RGV();
};


#pragma once
class RGV
{
private:
	int state;//0�ǳ�ʼ״̬ 1������״̬ 2��������״̬ 3���ƶ�״̬
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


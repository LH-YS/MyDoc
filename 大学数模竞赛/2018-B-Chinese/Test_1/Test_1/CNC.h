#pragma once
class CNC
{
private:
	int who;
	int num;//CNC���
	int state;//��ʾCNC��״̬ 0�ǿ���״̬ 1�ǹ���״̬ 2�ǵȴ�״̬ 3�Ǳ�ռ��״̬
	int work_time;//��ʾ�ѹ���ʱ��
	int sleep_time;//��ʾ˯��ʱ��
	int remaining_time;//ʣ��ʱ��
	int knife;//��Ƭ����
public:
	int pos;//λ��
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


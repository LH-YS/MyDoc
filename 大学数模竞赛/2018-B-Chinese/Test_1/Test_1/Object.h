#pragma once
class Object
{
private:
	int num;
	int state;//0就绪 1处理 2清洗 3完成
	int start_time;
	int finish_time;
	Object* next;
public:
	int get_num();
	void change_num(int a);
	int get_state();
	void change_state(int a);
	int get_start_time();
	void change_start_time(int a);
	int get_finish_time();
	void change_finish_time(int a);
	Object* get_next();
	void change_next(Object* a);
	Object();
	~Object();
};


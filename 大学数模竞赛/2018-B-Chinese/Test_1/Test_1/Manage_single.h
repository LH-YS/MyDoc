//这个类是单个工作流程的
#include "CNC.h"
#include "Object.h"
#include "RGV.h"
#pragma once
class Manage_single
{
private:
	int Time;//客观总时间
	Object* Prepare;//就绪队列
	Object* CNC_running;//CNC运行队列
	Object* RGV_running;//RGV运行队列
	Object* Finish;//完成队列
public:
	CNC* C = new CNC[8];
	RGV* R = new RGV;
	int NUM;
	CNC get_CNC(int a);
	RGV get_RGV();
	int get_Time();
	void change_Time(int a);
	void add_Time();
	void add_newObject();
	void SJF();
	int find_freeCNC();
	bool if_freeCNC();
	Object* get_Prepare();
	Object* get_CNC_running();
	Object* get_RGV_running();
	Object* get_Finish();
	Manage_single();
	~Manage_single();
	int abs1(int x);
	void output();
	//下面是系统作业参数
	int move1 = 18;
	int move2 = 32;
    int move3 = 46;
	int workneed = 545;
	int updown1 = 27;
	int updown2 = 32;
	int clean = 25;

};


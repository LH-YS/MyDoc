//������ǵ����������̵�
#include "CNC.h"
#include "Object.h"
#include "RGV.h"
#pragma once
class Manage_single
{
private:
	int Time;//�͹���ʱ��
	Object* Prepare;//��������
	Object* CNC_running;//CNC���ж���
	Object* RGV_running;//RGV���ж���
	Object* Finish;//��ɶ���
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
	//������ϵͳ��ҵ����
	int move1 = 18;
	int move2 = 32;
    int move3 = 46;
	int workneed = 545;
	int updown1 = 27;
	int updown2 = 32;
	int clean = 25;

};


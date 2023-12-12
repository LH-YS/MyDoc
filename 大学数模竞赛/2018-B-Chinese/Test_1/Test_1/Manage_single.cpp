#include "pch.h"
#include "Manage_single.h"
#include "CNC.h"
#include "Object.h"
#include "RGV.h"
#include <cstdlib>
#include <iostream>
using namespace std;
CNC Manage_single::get_CNC(int a)
{
	return C[a-1];
}

RGV Manage_single::get_RGV()
{
	return R[0];
}

int Manage_single::get_Time()
{
	return Time;
}

void Manage_single::change_Time(int a)
{
	Time = a;
}

void Manage_single::add_Time()
{
	for (int i = 0; i < 8; i++)
	{
		if(C[i].get_remaining_time()>0)
			C[i].change_remaining_time(C[i].get_remaining_time()-1);
		if (C[i].get_state() == 0)
			C[i].change_sleep_time(C[i].get_sleep_time() + 1);
		else if (C[i - 1].get_state() == 1)
			C[i].change_work_time(C[i].get_work_time() + 1);
	}
	if (R->get_state() == 0 || R->get_state() == 1)
		R->change_sleep_time(R->get_sleep_time() + 1);
	if (R->get_state() == 2)
		R->change_work_time(R->get_work_time() + 1);
	if (R->get_state() == 3)
		R->change_move_time(R->get_move_time() + 1);
	if(R->get_remaining_time()>0)
		R->change_remaining_time(R->get_remaining_time() - 1);
	change_Time(get_Time()+1);
}

void Manage_single::add_newObject()
{
	if (get_Prepare()->get_next() == NULL)
	{
		Object* temp = new Object;
		temp->change_num(NUM);
		temp->change_next(NULL);
		get_Prepare()->change_next(temp);
	}
	NUM++;
}

void Manage_single::SJF()
{
	//短作业优先
	add_newObject();
	while (Time < 28800)
	{
		//首先判断 如果剩余时间为0则转换为等待模式
		for (int i = 0; i < 8; i++)
		{
			if (C[i].get_remaining_time() == 0&& C[i].get_state()==1)
				C[i].change_state(2);
			if (R->get_remaining_time() == 0)
			{
				R->change_state(1);
				if (get_RGV_running()->get_next() != NULL)
				{
					Object* pos = get_Finish();
					while (pos->get_next()!=NULL)
					{
						pos = pos->get_next();
					}
					
					pos->change_next(get_RGV_running()->get_next());
					get_RGV_running()->change_next(NULL);
				}
			}
		}
		
		int flag1 = 0,flag2 = 0;//用来记录后面的情况
		if (R->get_state() == 0|| R->get_state() == 1)//如果RGV初始状态或者休眠状态 那么要看CNC
		{
			if (if_freeCNC() == false)//如果CNC没有空闲的 那RGV就进入休眠状态
			{
				R->change_state(1);
				add_Time();
				continue;
			}
			int t = find_freeCNC();
			
			flag1 = 1;
			if(abs1(C[t - 1].get_pos()- R->get_pos()) == 0)//如果不移动
				if (C[t - 1].get_state() == 0)//如果处于空闲 就开始任务
				{
					//从就绪队列拉到运行队列
					Object* temp = get_Prepare()->get_next();
					Object* pos = get_CNC_running();
					while (pos->get_next() != NULL)
						pos = pos->get_next();
					pos->change_next(temp);
					get_Prepare()->change_next(NULL);
					add_newObject();
					temp->change_start_time(get_Time());
					temp->change_state(1);
					//更新CNC状态
					if(C[t - 1].get_num()%2==1)
						C[t - 1].change_remaining_time(workneed + updown1);
					else
						C[t - 1].change_remaining_time(workneed + updown2);
					C[t - 1].change_state(1);
					C[t - 1].change_who(temp->get_num());
					//更新RGV状态
					R->change_state(2);
					if (C[t - 1].get_num() % 2 == 1)
						R->change_remaining_time(updown1);
					else
						R->change_remaining_time(updown2);
				}
				else if(C[t - 1].get_state() == 2)//如果处于任务完成状态 进行上下料作业
				{
					//拿出CNC运行队列
					Object* pos = get_CNC_running();
					while (pos->get_next() != NULL)
					{
						if (pos->get_next()->get_num() == C[t - 1].get_who())
							break;
						pos = pos->get_next();
					}
					Object* temp1 = pos->get_next();
					if(pos->get_next()->get_next()!=NULL)
						pos->change_next(pos->get_next()->get_next());
					else
						pos->change_next(NULL);
					temp1->change_next(NULL);
					temp1->change_state(2);//转化为清洗状态
					temp1->change_finish_time(get_Time());
					get_RGV_running()->change_next(temp1);
					R->change_state(2);
					if(C[t - 1].get_num() % 2 == 1)
						R->change_remaining_time(updown1+clean);
					else
						R->change_remaining_time(updown2+clean);
					//此时取出熟料后 放入生料 CNC转化成新的状态 这里可以把剩余时间整合一下 模拟上直接加入生料
					//从就绪队列拉到运行队列
					Object* temp = get_Prepare()->get_next();
					Object* pos2 = get_CNC_running();
					while (pos2->get_next() != NULL)
						pos2 = pos2->get_next();
					pos2->change_next(temp);
					get_Prepare()->change_next(NULL);
					add_newObject();
					temp->change_start_time(get_Time());
					temp->change_state(1);
					//更新CNC状态
					if (C[t - 1].get_num() % 2 == 1)
						C[t - 1].change_remaining_time(workneed + updown1);
					else
						C[t - 1].change_remaining_time(workneed + updown2);
					C[t - 1].change_state(1);
					C[t - 1].change_who(temp->get_num());
				}
			
			 if(abs1(C[t - 1].get_pos() - R->get_pos()) != 0)//如果需要移动
			 {
				
			   if (abs1(C[t - 1].get_pos() - R->get_pos()) == 1)
					R->change_remaining_time(move1);
			   if (abs1(C[t - 1].get_pos() - R->get_pos()) == 2)
					R->change_remaining_time(move2);
			   if (abs1(C[t - 1].get_pos() - R->get_pos()) == 3)
					get_RGV().change_remaining_time(move3);
			   R->change_pos(C[t - 1].get_pos());
			   R->change_state(3);
			  }
			
			
		}
		add_Time();
	}
	output();
}

int Manage_single::find_freeCNC()
{
	int a = 0;
	int min = 99999;
	for (int i = 0; i < 8; i++)
	{
		if (C[i].get_state() == 0|| C[i].get_state() == 2)//说明空闲
		{
			//找到空闲的CNC就计算他们的移动位置 并记录最短程的那个
			if (abs1(C[i].get_pos() - R->get_pos()) < min)
			{
				min = abs1(C[i].get_pos() - R->get_pos());
				a = C[i].get_num();
			}
		}
	}
	return a;
}



bool Manage_single::if_freeCNC()
{
	bool a = false;
	for (int i = 0; i < 8; i++)
	{
		if (C[i].get_state() == 0 || C[i].get_state() == 2)//说明空闲
		{
			a = true;
		}
	}
	return a;
}


Object * Manage_single::get_Prepare()
{
	return Prepare;
}

Object * Manage_single::get_CNC_running()
{
	return CNC_running;
}

Object * Manage_single::get_RGV_running()
{
	return RGV_running;
}

Object * Manage_single::get_Finish()
{
	return Finish;
}

Manage_single::Manage_single()
{
	
	Time = 0;
	
	for (int i = 1; i < 9; i++) 
	{
		C[i - 1].change_num(i);
		C[i - 1].create();
	}
	Prepare = new Object;
	CNC_running = new Object;
	RGV_running = new Object;
	Finish = new Object;
	NUM = 1;

}


Manage_single::~Manage_single()
{
}

int Manage_single::abs1(int x)
{
	if (x >= 0)
		return x;
	else
		return -x;
}

void Manage_single::output()
{
	cout << NUM << endl;
	Object* pos = get_Finish()->get_next();
	while (pos!=NULL)
	{
		cout << pos->get_num() << "    " << pos->get_start_time() << "    " << pos->get_finish_time() << endl;
		pos = pos->get_next();
	}
	cout << endl << R->get_move_time() << "   " << R->get_sleep_time() << "   " << R->get_work_time();
	for (int i = 0; i < 8; i++)
	{
		cout << endl << C[i].get_work_time() <<"     "<< C[i].get_sleep_time();
	}
}

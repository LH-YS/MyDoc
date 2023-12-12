#include "pch.h"
#include "CNC.h"


void CNC::create()
{
	if (this->num == 1 || this->num == 2)
		pos = 1;
	else if (this->num == 3 || this->num == 4)
		pos = 2;
	else if (this->num == 5 || this->num == 6)
		pos = 3;
	else if (this->num == 7 || this->num == 8)
		pos = 4;
}

int CNC::get_who()
{
	return who;
}

void CNC::change_who(int a)
{
	who = a;
}

int CNC::get_num()
{
	return num;
}

void CNC::change_num(int a)
{
	num = a;
}

int CNC::get_pos()
{
	return pos;
}

int CNC::get_state()
{
	return state;
}

void CNC::change_state(int a)
{
	state = a;
}

int CNC::get_work_time()
{
	return work_time;
}

void CNC::change_work_time(int a)
{
	work_time = a;
}

int CNC::get_sleep_time()
{
	return sleep_time;
}

int CNC::get_remaining_time()
{
	return remaining_time;
}

void CNC::change_remaining_time(int a)
{
	remaining_time = a;
}

void CNC::change_sleep_time(int a)
{
	sleep_time = a;
}

int CNC::get_knife()
{
	return knife;
}

CNC::CNC()
{
	state = 0;
	work_time = 0;
	sleep_time = 0;
	remaining_time = 0;
	who = 0;
	knife = 1;
}


CNC::~CNC()
{
}

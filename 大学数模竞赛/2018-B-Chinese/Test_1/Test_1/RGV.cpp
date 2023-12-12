#include "pch.h"
#include "RGV.h"


int RGV::get_state()
{
	return state;
}

void RGV::change_state(int a)
{
	state = a;
}

int RGV::get_work_time()
{
	return work_time;
}

void RGV::change_work_time(int a)
{
	work_time = a;
}

int RGV::get_move_time()
{
	return move_time;
}

void RGV::change_move_time(int a)
{
	move_time = a;
}

int RGV::get_sleep_time()
{
	return sleep_time;
}

void RGV::change_sleep_time(int a)
{
	sleep_time = a;
}

int RGV::get_remaining_time()
{
	return remaining_time;
}

void RGV::change_remaining_time(int a)
{
	remaining_time = a;
}

int RGV::get_pos()
{
	return pos;
}

void RGV::change_pos(int a)
{
	pos = a;
}

RGV::RGV()
{
	state = 0;
	work_time = 0;
	move_time = 0;
	sleep_time = 0;
	remaining_time = 0;
	pos = 1;
}


RGV::~RGV()
{
}

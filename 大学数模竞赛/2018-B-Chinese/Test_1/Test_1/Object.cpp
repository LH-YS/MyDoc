#include "pch.h"
#include "Object.h"
#include <iostream>

int Object::get_num()
{
	return num;
}

void Object::change_num(int a)
{
	num = a;
}

int Object::get_state()
{
	return state;
}

void Object::change_state(int a)
{
	state = a;
}

int Object::get_start_time()
{
	return start_time;
}

void Object::change_start_time(int a)
{
	start_time = a;
}

int Object::get_finish_time()
{
	return finish_time;
}

void Object::change_finish_time(int a)
{
	finish_time = a;
}

Object* Object::get_next()
{
	return next;
}

void Object::change_next(Object * a)
{
	next = a;
}


Object::Object()
{
	num = 0;
	start_time = 0;
	finish_time = 0;
	state = 0;
	next = NULL;
}


Object::~Object()
{
}

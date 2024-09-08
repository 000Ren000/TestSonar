﻿
#Область ПрограммныйИнтерфейс

#Область ФормаНастройкиРегистрацииККТ

// Выполняет открытие формы настроек для регистрации ККТ
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения
//  ПараметрыОткрытия - см. ОборудованиеЧекопечатающиеУстройстваКлиент.ПараметрыФормаНастройкиРегистрацииККТ.
Процедура ОткрытьФормуНастройкиРегистрацииККТ(ОповещениеПриЗавершении, ПараметрыОткрытия) Экспорт
	
	// ++ Локализация
	ОткрытьФорму("ОбщаяФорма.НастройкаРегистрацииККТ", 
		ПараметрыОткрытия,
		,
		,
		,
		,
		ОповещениеПриЗавершении, 
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	// -- Локализация
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
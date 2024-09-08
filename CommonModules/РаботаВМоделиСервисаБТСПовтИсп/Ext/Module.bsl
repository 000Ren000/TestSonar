﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность в модели сервиса".
// Серверные процедуры и функции общего назначения:
// - Поддержка работы в модели сервиса.
//
////////////////////////////////////////////////////////////////////////////////
// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает конечную точку для отправки сообщений в менеджер сервиса.
//
// Возвращаемое значение:
//  ПланОбменаСсылка.ОбменСообщениями - узел соответствующий менеджеру сервиса.
//
Функция КонечнаяТочкаМенеджераСервиса() Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.КонечнаяТочкаМенеджераСервиса();
	
КонецФункции

// Возвращает HTTP-соединение с Менеджером сервиса.
// Вызывающий код должен самостоятельно устанавливать привилегированный режим.
// 
// Параметры: 
//  ДанныеСервера - см. ОбщегоНазначенияКлиентСервер.СтруктураURI
//  Таймаут - Число - см. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса.Таймаут
// 
// Возвращаемое значение: 
//  HTTPСоединение - соединение с менеджером сервиса
// (См. РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса)
Функция СоединениеСМенеджеромСервиса(ДанныеСервера, Таймаут = 60) Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.СоединениеСМенеджеромСервиса(ДанныеСервера, Таймаут);
	
КонецФункции

Функция АдресПровайдераАутентификации() Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.АдресПровайдераАутентификации()
	
КонецФункции

Функция АутентификацияТокеномДоступаВнутреннихВызововПрограммногоИнтерфейса() Экспорт
	
	Возврат РаботаВМоделиСервисаБТС.АутентификацияТокеномДоступаВнутреннихВызововПрограммногоИнтерфейса();
	
КонецФункции

#КонецОбласти

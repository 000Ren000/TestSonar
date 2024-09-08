﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Записывает ставку процентов и ставку комиссии по договору кредита, депозита, займа.
//
// Параметры:
//	 Договор - СправочникСсылка.ДоговорыКредитовИДепозитов - договор кредита, депозита, займа.
//	 НоваяСтавка - Число - ставка процентов по договору.
//	 НоваяКомиссия - Число - процент комиссии по договору.
//	 Период - Дата - дата с которой начинают действовать процентные ставки по договору. По умолчанию текущая дата.
//
Процедура ЗаписатьПроцентнуюСтавкуКомисии(Договор, НоваяСтавка, НоваяКомиссия, Период = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Договор.Установить(Договор);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() <= 1 Тогда
		ИсторияСтавок = НаборЗаписей.Выгрузить();
		Если ИсторияСтавок.Количество() = 0 Тогда
			СтрокаДанных = ИсторияСтавок.Добавить();
		Иначе
			СтрокаДанных = ИсторияСтавок[0];
		КонецЕсли;
		СтрокаДанных.Период         = Период;
		СтрокаДанных.Договор        = Договор;
		СтрокаДанных.Процент        = НоваяСтавка;
		СтрокаДанных.Комиссия       = НоваяКомиссия;
		СтрокаДанных.ДатаИзменения  = ТекущаяДатаСеанса();
		СтрокаДанных.АвторИзменения = Пользователи.ТекущийПользователь();
		НаборЗаписей.Загрузить(ИсторияСтавок);
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Получает ставку процентов и ставку комиссии по договору кредита, депозита, займа.
//
// Параметры:
//    Договор - СправочникСсылка.ДоговорыКредитовИДепозитов - договор кредита, депозита, займа.
//    НоваяСтавка - Число - будет помещена ставка процентов по договору.
//    НоваяКомиссия - Число - будет помещен процент комиссии по договору.
//    Период - Дата - дата с которой начинают действовать процентные ставки по договору. По умолчанию текущая дата.
//
//Возвращаемое значение:
//    Структура - Ставка, Комиссия и флаг наличия нескольких записей
//
Функция ПрочитатьПроцентнуюСтавкуКомиссии(Договор, Период = Неопределено) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Процент", 0);
	Результат.Вставить("Комиссия", 0);
	Результат.Вставить("Период", '00010101');
	Результат.Вставить("ЕстьИстория", Ложь);
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ИсторияСтавок = СрезПоследних(Период, Новый Структура("Договор", Договор));
	Если ИсторияСтавок.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Результат, ИсторияСтавок[0]);
		Результат.ЕстьИстория = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
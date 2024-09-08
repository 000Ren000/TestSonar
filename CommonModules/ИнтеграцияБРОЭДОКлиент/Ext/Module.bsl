﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ОткрытьФормуНастроекРегистрацииЭДО(Знач Настройки, Знач ВыполняемоеОповещение) Экспорт
	
	Операция = ИнтеграцияБРОЭДОСлужебныйВызовСервера.ОперацияЭДОИзСтроки(Настройки);
	
	ОбработкаЗакрытия = Новый ОписаниеОповещения("ЗакрытиеФормыНастроекРегистрацииЭДО", ИнтеграцияБРОЭДОСлужебныйКлиент, ВыполняемоеОповещение);
	
	ОперацияПодключенияЭДО = СинхронизацияЭДОКлиентСервер.НоваяОперацияПодключенияЭДО();
	
	Если Операция.Действие = ОперацияПодключенияЭДО.Действие Тогда
		ПараметрыСоздания = СинхронизацияЭДОКлиент.НовыеПараметрыСозданияУчетнойЗаписи();
		ПараметрыСоздания.Организация           = Операция.Параметры.Организация;
		ПараметрыСоздания.ОперацияЭДО           = Операция;
		ПараметрыСоздания.НастройкаОперацииЭДО  = Истина;
		ПараметрыСоздания.ОповещениеОЗавершении = ОбработкаЗакрытия;
		СинхронизацияЭДОКлиент.СоздатьУчетнуюЗапись(ПараметрыСоздания);
			
	Иначе
		
		ВыполнитьОбработкуОповещения(ОбработкаЗакрытия, Операция);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуОтправкиДанныхОператоруЭДО(Знач Настройки, Знач Сертификат ,Знач ВыполняемоеОповещение) Экспорт
	
	Операция = ИнтеграцияБРОЭДОСлужебныйВызовСервера.ОперацияЭДОИзСтроки(Настройки);
	
	Контекст = Новый Структура;
	Контекст.Вставить("Операция", Операция);
	Контекст.Вставить("Настройки", Настройки);
	Контекст.Вставить("ВыполняемоеОповещение", ВыполняемоеОповещение);
	
	ОбработчикПродолжения = Новый ОписаниеОповещения("ОткрытьФормуОтправкиДанныхОператоруЭДО_ПослеПоискаСертификата", 
		ИнтеграцияБРОЭДОСлужебныйКлиент, Контекст);
	КриптографияБЭДКлиент.НайтиСоздатьСертификатКриптографии(Base64Строка(Сертификат.Отпечаток), Операция.Параметры.Организация, ОбработчикПродолжения);
	
КонецПроцедуры

#КонецОбласти


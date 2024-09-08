﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, используемые в обработке ЖурналДокументовЗакупки
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Печатает образец локализованных этикеток
// 
// Параметры:
// 	ПараметрыДляПечатиОбразца - Структура - Параметры для печати
// 	ПараметрКоманды - Структура - Параметр команды
// 	Контекст - ФормаКлиентскогоПриложения - Контекст для получения данных
Процедура НапечататьОбразец(ПараметрыДляПечатиОбразца, ПараметрКоманды, Контекст) Экспорт
	//++ Локализация
	
	ПараметрКоманды.Очистить();
	ПараметрКоманды.Добавить(Контекст.ДляЧего);
	
	Если Контекст.Назначение = ПредопределенноеЗначение(
		"Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляАкцизныхМарок") Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ПечатьЭтикетокИЦенников",
			"ЭтикеткаАкцизныеМарки",
			ПараметрКоманды,
			Неопределено, 
			ПараметрыДляПечатиОбразца);
			
	ИначеЕсли Контекст.Назначение = ПредопределенноеЗначение(
		"Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляШтрихкодовУпаковок") Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Обработка.ПечатьЭтикетокИЦенников",
			"ЭтикеткаШтрихкодыУпаковки",
			ПараметрКоманды,
			Неопределено,
			ПараметрыДляПечатиОбразца);
	
	ИначеЕсли Контекст.Назначение = ПредопределенноеЗначение(
		"Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП") Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Справочник.ШтрихкодыУпаковокТоваров",
			"ЭтикеткаКодМаркировкиИСМП",
			ПараметрКоманды,
			Неопределено,
			ПараметрыДляПечатиОбразца);
	КонецЕсли;
	//-- Локализация
КонецПроцедуры

// Печатает этикетки акцизных марок
// 
// Параметры:
// 	ПараметрыДляПечатиАкцизныхМарок - Структура - Параметры для печати
// 	Контекст - ФормаКлиентскогоПриложения - Контекст для получения данных
Процедура ПечатьЭтикеткаАкцизныеМарки(ПараметрыДляПечатиАкцизныхМарок, Контекст) Экспорт
	//++ Локализация	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Документ.ЗапросАкцизныхМарокЕГАИС.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьЭтикетокИЦенников",
		"ЭтикеткаАкцизныеМарки",
		ПараметрКоманды,
		Контекст,
		ПараметрыДляПечатиАкцизныхМарок);
	//-- Локализация
КонецПроцедуры

#КонецОбласти


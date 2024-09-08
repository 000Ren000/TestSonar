﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

	СформироватьПредставлениеУпаковки();
	УправлениеЭлементамиФормы(ЭтотОбъект);
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ИмпортируемаяПартияСАТУРН"
		И Параметр = Объект.Ссылка Тогда
		
		Прочитать();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СобытияФормИСКлиент.ОбработкаНавигационнойСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Объект.Ссылка;
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка, ПараметрОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеУпаковкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьУпаковочнуюЕдиницу" Тогда
	
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Объект.УпаковочнаяЕдиница);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьИзСервиса(Команда)
	
	ПараметрОповещения = ЗагрузитьИмпортируемуюПартиюНаСервере();
	ОбщегоНазначенияКлиент.ОповеститьОбИзмененииОбъекта(Объект.Ссылка, ПараметрОповещения);
	
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ДанныеСАТУРН(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор",                 Объект.Идентификатор);
	ПараметрыФормы.Вставить("НеПоказыватьСостояниеЗагрузки", Истина);
	
	ОткрытьФорму(
		"Справочник.ИмпортируемаяПартияСАТУРН.Форма.ДанныеКлассификатора",
		ПараметрыФормы, ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗагрузитьИмпортируемуюПартиюНаСервере()
	
	Результат = ИнтерфейсСАТУРНВызовСервера.ИмпортируемаяПартияПоИдентификатору(Объект.Идентификатор);
		
	Если Не ПустаяСтрока(Результат.ТекстОшибки) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		
	Иначе
		
		ДанныеПартии = ИнтерфейсСАТУРН.ДанныеИмпортируемойПартии(Результат.Элемент);
		Партия = ИнтеграцияСАТУРН.ЗагрузитьИмпортируемуюПартию(ДанныеПартии,, Результат.ПараметрыОбмена); 
		
	КонецЕсли;
	
	Возврат Партия;
	
КонецФункции

&НаСервере
Процедура СформироватьПредставлениеУпаковки()
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	Строки = Новый Массив;
	Строки.Добавить(Формат(Объект.КоличествоУпаковок, "ЧРД=; ЧГ=3,0;"));
	Строки.Добавить(НСтр("ru = ' шт.'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Объект.УпаковочнаяЕдиница),, ЦветГиперссылки,, "ОткрытьУпаковочнуюЕдиницу"));
	
	ПредставлениеУпаковки = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ФормаОбновитьИзСервиса.Видимость = ЗначениеЗаполнено(Объект.Идентификатор);
	Элементы.ФормаДанныеСАТУРН.Видимость      = ЗначениеЗаполнено(Объект.Идентификатор);
	
	Элементы.ТребуетсяЗагрузка.Видимость      = Объект.ТребуетсяЗагрузка;
	
КонецПроцедуры

#КонецОбласти
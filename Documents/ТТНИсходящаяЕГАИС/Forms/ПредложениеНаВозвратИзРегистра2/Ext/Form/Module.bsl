﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.ДокументОснование = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие формы только из документов.'");
	КонецЕсли;
	
	ДокументОснование = Параметры.ДокументОснование;
	
	СформироватьТекстДокументаЕГАИС();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ВыполненОбменЕГАИС"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
	
		СформироватьТекстДокументаЕГАИС();
	
	КонецЕсли;
	
	// Обновление гиперссылки на создание документа Возврат из регистра №2
	Если ИмяСобытия = "Запись_ВозвратИзРегистра2ЕГАИС"
		И Параметр.Основание = ДокументОснование Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ИзменениеСостоянияЕГАИС"
		И Параметр.Основание = ДокументОснование Тогда
		
		СформироватьТекстДокументаЕГАИС();
		
	КонецЕсли;
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ОбменДаннымиЕГАИСКлиент.ТекстДокументаЕГАИСОбработкаНавигационнойСсылки(ВладелецФормы, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьСправки2(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда) Экспорт
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьТекстДокументаЕГАИС(ОткрытиеФормы = Ложь)
	
	ТекстДокументаЕГАИС = "";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтатусыОформленияДокументовЕГАИС.Документ,
	|	СтатусыОформленияДокументовЕГАИС.СтатусОформления КАК Статус
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовЕГАИС КАК СтатусыОформленияДокументовЕГАИС
	|ГДЕ
	|	СтатусыОформленияДокументовЕГАИС.Основание = &Основание
	|");
	
	Запрос.УстановитьПараметр("Основание", ДокументОснование);
	ДанныеПоСтатусам = Запрос.Выполнить().Выгрузить();
	
	СтатусыОформления = Новый Структура;
	Для Каждого СтрокаТЧ Из ДанныеПоСтатусам Цикл
		СтатусыОформления.Вставить(СтрокаТЧ.Документ.Метаданные().Имя, СтрокаТЧ.Статус);
	КонецЦикла;
	
	ДокументыПоОснованию = ИнтеграцияЕГАИСВызовСервера.ДокументыПоОснованию(ДокументОснование);
	Данные = ИнтеграцияЕГАИС.ДанныеДокументаЕГАИС(Метаданные.Документы.ВозвратИзРегистра2ЕГАИС, ДокументыПоОснованию, СтатусыОформления);
	
	ФорматированныеСтроки = Новый Массив;
	ФорматированныеСтроки.Добавить(Данные.Представление);
	
	ТекстДокументаЕГАИС = Новый ФорматированнаяСтрока(ФорматированныеСтроки);
	
КонецПроцедуры

#КонецОбласти
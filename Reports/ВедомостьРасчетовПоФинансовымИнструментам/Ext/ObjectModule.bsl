﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	КомпоновщикНастроекФормы = ЭтаФорма.Отчет.КомпоновщикНастроек;
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		ЭтаФорма.ФормаПараметры.Отбор = Новый Структура;
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("Договор", Параметры.ПараметрКоманды);
		
		ЭтаФорма.ФормаПараметры.КлючНазначенияИспользования = "Договор";
		Параметры.КлючНазначенияИспользования = "Договор";
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХарактерДоговора
		|ИЗ
		|	Справочник.ДоговорыКредитовИДепозитов
		|ГДЕ
		|	Ссылка В (&Договоры)
		|";
		
		Запрос.УстановитьПараметр("Договоры", Параметры.ПараметрКоманды);
		
		СписокФинансовыхИнструментов = Новый СписокЗначений;
		СписокФинансовыхИнструментов.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ХарактерДоговора"));
		
		ЭтаФорма.ФормаПараметры.Отбор.Вставить("ФинансовыйИнструмент", СписокФинансовыхИнструментов);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
	
	ДоступныеПараметрыКД = КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.ДоступныеПараметры; // ДоступныеПараметрыКомпоновкиДанных 
	
	ПараметрФинансовыйИнструмент = ДоступныеПараметрыКД.Элементы.Найти("ФинансовыйИнструмент");
	Если ПараметрФинансовыйИнструмент <> Неопределено Тогда
		
		СписокФинансовыхИнструментов = ПараметрФинансовыйИнструмент.ДоступныеЗначения;
		СписокФинансовыхИнструментов.Очистить();
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
			СписокФинансовыхИнструментов.Добавить(
				Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм, НСтр("ru = 'Кредиты или займы полученные'"));
			СписокФинансовыхИнструментов.Добавить(
				Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Депозит, НСтр("ru = 'Депозит'"));
			СписокФинансовыхИнструментов.Добавить(
				Перечисления.ХарактерыДоговоровФинансовыхИнструментов.ЗаймВыданный, НСтр("ru = 'Займы выданные'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоУмолчанию(КомпоновщикНастроекФормы, ПользовательскиеНастройки = Ложь)
	
	ФиксНастройкаПериода = ФиксированнаяНастройкаПараметра(КомпоновщикНастроекФормы, "Период");
	
	Если ФиксНастройкаПериода.Использование = Истина Тогда
		
		ФиксНастройкаСтандартныйПериод = ФиксНастройкаПериода.Значение; // СтандартныйПериод
		
		ПользНастройкаПериода = ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, "Период");
		ПользНастройкаПериода.Использование = Истина;
		
		ПользНастройкаПериодаСтандартныйПериод = ПользНастройкаПериода.Значение; // СтандартныйПериод
		
		ПользНастройкаПериодаСтандартныйПериод.ДатаНачала = ФиксНастройкаСтандартныйПериод.ДатаНачала;
		ПользНастройкаПериодаСтандартныйПериод.ДатаОкончания = ФиксНастройкаСтандартныйПериод.ДатаОкончания;
		
		ФиксНастройкаПериода.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Функция ФиксированнаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)
	
	ПараметрыДанныхКД = КомпоновщикНастроекФормы.ФиксированныеНастройки.ПараметрыДанных; // ЗначенияПараметровДанныхКомпоновкиДанных
	
	Возврат ПараметрыДанныхКД.Элементы.Найти(ИмяПараметра);
	
КонецФункции

Функция ПользовательскаяНастройкаПараметра(КомпоновщикНастроекФормы, ИмяПараметра)
	
	Результат = Неопределено;
	
	ПараметрыДанныхКД = КомпоновщикНастроекФормы.Настройки.ПараметрыДанных; // ЗначенияПараметровДанныхКомпоновкиДанных
	
	ПараметрДанных = ПараметрыДанныхКД.Элементы.Найти(ИмяПараметра);
	Если ПараметрДанных <> Неопределено Тогда
		ПользовательскиеНастройкиКД = КомпоновщикНастроекФормы.ПользовательскиеНастройки; // ПользовательскиеНастройкиКомпоновкиДанных
		ПараметрПользовательскойНастройки = ПользовательскиеНастройкиКД.Элементы.Найти(ПараметрДанных.ИдентификаторПользовательскойНастройки);
		Если ПараметрПользовательскойНастройки <> Неопределено Тогда
			Результат = ПараметрПользовательскойНастройки;
		Иначе
			Результат = ПараметрДанных;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ЗаписатьПослеВопроса; // Для отработки вопроса после записи

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	Если Параметры.Свойство("Партнер") Тогда
		Объект.Владелец = ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(Параметры.Партнер);
	ИначеЕсли Параметры.Свойство("ПоВладельцу") Тогда
		Элементы.Владелец.ТолькоПросмотр = Истина;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗаписатьПослеВопроса = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Владелец) И ЗначениеЗаполнено(Объект.Наименование) Тогда
		СтруктураКлючевыхПолейЛицензий = Новый Структура("Ссылка,Владелец,ВидЛицензии,ДатаНачала,ДатаОкончания");
		ЗаполнитьЗначенияСвойств(СтруктураКлючевыхПолейЛицензий, Объект);
		СписокЛицензий = ПересекающиесяЛицензии(СтруктураКлючевыхПолейЛицензий);
		
		Если СписокЛицензий.Количество() > 0 Тогда
			
			СписокКнопок = Новый СписокЗначений;
			Если СписокЛицензий.Количество() = 1 Тогда
				ТекстВопроса = НСтр("ru='В информационной базе уже есть лицензия такого же вида c периодом действия, пересекающимся с указанным. Записать?'");
				СписокКнопок.Добавить("ОткрытьСписокЛицензий", НСтр("ru = 'Открыть лицензию'"));
			Иначе
				ТекстВопроса = НСтр("ru='В информационной базе уже есть лицензии такого же вида c периодом действия, пересекающимся с указанным. Записать?'");
				СписокКнопок.Добавить("ОткрытьСписокЛицензий", НСтр("ru = 'Открыть список лицензий'"));
			КонецЕсли;
			
			СписокКнопок.Добавить("Записать", НСтр("ru = 'Записать'"));
			СписокКнопок.Добавить("ЗаписатьЗакрыть", НСтр("ru = 'Записать и закрыть'"));
			СписокКнопок.Добавить("Отмена", НСтр("ru = 'Отмена'"));
			
			ПоказатьВопрос(
				Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект, Новый Структура("СписокЛицензий", СписокЛицензий)),
				ТекстВопроса, СписокКнопок);
            Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	СписокЛицензий = ДополнительныеПараметры.СписокЛицензий;
	
	Если РезультатВопроса = "Записать" Тогда
		ЗаписатьПослеВопроса = Истина;
		Записать();
	ИначеЕсли РезультатВопроса = "ЗаписатьЗакрыть" Тогда
		ЗаписатьПослеВопроса = Истина;
		Записать();
		Закрыть();
	ИначеЕсли РезультатВопроса = "ОткрытьСписокЛицензий" Тогда
		
		Если СписокЛицензий.Количество() > 1 Тогда
			ОткрытьФорму(
				"ОбщаяФорма.ПросмотрСпискаДокументов",
				Новый Структура("СписокДокументов, Заголовок",
				СписокЛицензий,
				НСтр("ru='Лицензии поставщиков алкогольной продукции (%КоличествоДокументов%)'")));
		Иначе
			
			ПараметрыФормы = Новый Структура("Ключ", СписокЛицензий[0].Значение);
			ОткрытьФорму("Справочник.ЛицензииПоставщиковАлкогольнойПродукции.ФормаОбъекта", ПараметрыФормы);
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.ЛицензииПоставщиковАлкогольнойПродукции.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
        ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция ПересекающиесяЛицензии(СтруктураКлючевыхПолейЛицензий)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийЭлемент", 	СтруктураКлючевыхПолейЛицензий.Ссылка);
	Запрос.УстановитьПараметр("Владелец", 			СтруктураКлючевыхПолейЛицензий.Владелец);
	Запрос.УстановитьПараметр("ВидЛицензии", 		СтруктураКлючевыхПолейЛицензий.ВидЛицензии);
	Запрос.УстановитьПараметр("ДатаНачала", 		СтруктураКлючевыхПолейЛицензий.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", 		СтруктураКлючевыхПолейЛицензий.ДатаОкончания);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Спр.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЛицензииПоставщиковАлкогольнойПродукции КАК Спр
	|ГДЕ
	|	Спр.Ссылка <> &ТекущийЭлемент
	|	И Спр.Владелец = &Владелец
	|	И Спр.ВидЛицензии = &ВидЛицензии
	|	И (Спр.ДатаНачала <= &ДатаНачала
	|				И (Спр.ДатаОкончания >= &ДатаНачала
	|					ИЛИ Спр.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|			ИЛИ Спр.ДатаНачала <= &ДатаОкончания
	|				И (Спр.ДатаОкончания >= &ДатаОкончания
	|					ИЛИ Спр.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|			ИЛИ Спр.ДатаНачала >= &ДатаНачала
	|				И (Спр.ДатаНачала <= &ДатаОкончания
	|					ИЛИ &ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1)))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаНачала";
	
	СписокЛицензий = Новый СписокЗначений;
	
	СписокЛицензий.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат СписокЛицензий;
	
КонецФункции

#КонецОбласти

#КонецОбласти

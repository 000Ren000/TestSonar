﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");

	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");

	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма, Объект, Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	
	ПравоПросмотраВзаимодействий = ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.Взаимодействия);
	УстановитьТекстДекорацииКоличествоВзаимодействий(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВзаимодействияКлиентСервер.ЯвляетсяВзаимодействием(Источник) И Параметр.Предмет = Задание.Предмет Тогда
		
		УстановитьТекстДекорацииКоличествоВзаимодействий(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить()

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма,Истина,Новый Структура("Сделка",Объект.Предмет));

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекстДекорацииКоличествоВзаимодействий(Форма)
	
	Если Форма.ПравоПросмотраВзаимодействий Тогда
		
		КоличествоВзаимодействий = КоличествоВзаимодействий(Форма.Задание.Предмет);
		ТекстИнформации = СтрШаблон(НСтр("ru='Взаимодействия (%1)'"), Строка(КоличествоВзаимодействий));
		
	Иначе
		
		ТекстИнформации = НСтр("ru = 'Нет прав для просмотра взаимодействий'");
		
	КонецЕсли;
	
	Форма.Элементы.ДекорацияВзаимодействия.Заголовок = ТекстИнформации;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоВзаимодействий(Сделка)

	Если НЕ ПравоДоступа("Чтение",Метаданные.ЖурналыДокументов.Взаимодействия) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КОЛИЧЕСТВО(*) КАК КоличествоВзаимодействий
		|ИЗ
		|	ЖурналДокументов.Взаимодействия КАК Взаимодействия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|		ПО Взаимодействия.Ссылка = ПредметыПапкиВзаимодействий.Взаимодействие
		|ГДЕ
		|	(НЕ Взаимодействия.ПометкаУдаления)
		|	И ТИПЗНАЧЕНИЯ(Взаимодействия.Ссылка) <> ТИП(Документ.ЗапланированноеВзаимодействие)
		|	И ПредметыПапкиВзаимодействий.Предмет = &Предмет");
	Запрос.УстановитьПараметр("Предмет", Сделка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.КоличествоВзаимодействий;

КонецФункции

&НаКлиенте
Процедура ДекорацияВзаимодействияНажатие(Элемент)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Предмет", Объект.Предмет);
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТипВзаимодействия", "Предмет");
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", СтруктураОтбора);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);

	
	ОткрытьФорму(
		"ЖурналДокументов.Взаимодействия.Форма.ФормаСпискаПараметрическая",
		ПараметрыФормы,
		ЭтотОбъект,
		ЭтотОбъект.КлючУникальности);
	
КонецПроцедуры

#КонецОбласти

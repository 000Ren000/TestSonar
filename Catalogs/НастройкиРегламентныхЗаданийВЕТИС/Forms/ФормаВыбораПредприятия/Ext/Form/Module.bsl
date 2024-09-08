﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("Предприятия") Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Не заданы предприятия для выбора'"),,,, Отказ);
	КонецЕсли;
	
	ТаблицаДляЗаполнения = ИнтеграцияВЕТИС.ИнициализироватьТаблицуОрганизацияПредприятиеВЕТИС();
	Для Каждого ЭлементДанных Из Параметры.Предприятия Цикл
		Строка = ТаблицаДляЗаполнения.Добавить();
		Строка.Организация = ЭлементДанных.ХозяйствующийСубъект;
		Строка.Предприятие = ЭлементДанных.Предприятие;
	КонецЦикла;
	
	ЗаполнитьПредприятия(ТаблицаДляЗаполнения);
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПредприятия

&НаКлиенте
Процедура ПредприятияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьВыбор(Команда)
	
	ЗакрытьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредприятия(ТаблицаДляЗаполнения)
	
	Предприятия.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица", ТаблицаДляЗаполнения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Организация КАК ХозяйствующийСубъект,
	|	Таблица.Предприятие КАК Предприятие
	|ПОМЕСТИТЬ Таблица
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ХозяйствующиеСубъекты.Ссылка КАК ХозяйствующийСубъект,
	|	ХозяйствующиеСубъекты.Наименование КАК ХозяйствующийСубъектНаименование,
	|	Таблица.Предприятие КАК Предприятие,
	|	ПредприятияВЕТИС.Наименование КАК ПредприятиеНаименование,
	|	ПредприятияВЕТИС.АдресПредставление КАК ПредприятиеАдрес,
	|	ВЫБОР
	|		КОГДА Таблица.Предприятие = ЗНАЧЕНИЕ(Справочник.ПредприятияВЕТИС.ПустаяСсылка)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	Таблица КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ХозяйствующиеСубъектыВЕТИС КАК ХозяйствующиеСубъекты
	|		ПО Таблица.ХозяйствующийСубъект = ХозяйствующиеСубъекты.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредприятияВЕТИС КАК ПредприятияВЕТИС
	|		ПО Таблица.Предприятие = ПредприятияВЕТИС.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ХозяйствующийСубъектНаименование,
	|	Порядок,
	|	ПредприятиеНаименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Строка = Предприятия.Добавить();
		Строка.ХозяйствующийСубъект = Выборка.ХозяйствующийСубъект;
		Строка.Предприятие = Выборка.Предприятие;
		Если ЗначениеЗаполнено(Строка.Предприятие) Тогда
			Представление = СтрШаблон("%1, %2 (%3)",
						Выборка.ХозяйствующийСубъектНаименование,
						Выборка.ПредприятиеНаименование,
						Выборка.ПредприятиеАдрес);
		Иначе
			Представление = СтрШаблон("%1, %2",
						Выборка.ХозяйствующийСубъектНаименование,
						НСтр("ru = '<Без предприятия>'"));
		КонецЕсли;
		Строка.Представление = Представление;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	
	ТекущиеДанные = Элементы.Предприятия.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура;
		Результат.Вставить("ХозяйствующийСубъект", ТекущиеДанные.ХозяйствующийСубъект);
		Результат.Вставить("Предприятие",          ТекущиеДанные.Предприятие);
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти
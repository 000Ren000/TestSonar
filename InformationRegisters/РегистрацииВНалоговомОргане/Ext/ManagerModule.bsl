﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Удаляет из регистра сведений РегистрацииВНалоговомОргане записи, которые стали
//	некорректными после изменения организации в элементе справочника РегистрацииВНалоговомОргане.
//
//	Параметры:
//		РегистрацияВНалоговомОргане - СправочникОбъект.РегистрацииВНалоговомОргане - регистрация в налоговом органе,
//			для которой необходимо выполнить актуализацию.
//
Процедура АктуализироватьСоставРегистрацииВНалоговомОргане(РегистрацияВНалоговомОргане) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацииВНалоговомОргане.Подразделение,
	|	РегистрацииВНалоговомОргане.Организация
	|ИЗ
	|	РегистрСведений.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|ГДЕ
	|	РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане = &Ссылка
	|	И РегистрацииВНалоговомОргане.Организация.ГоловнаяОрганизация <> &Владелец";
	
	Запрос.УстановитьПараметр("Ссылка",   РегистрацияВНалоговомОргане.Ссылка);
	Запрос.УстановитьПараметр("Владелец", РегистрацияВНалоговомОргане.Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Запись = РегистрыСведений.РегистрацииВНалоговомОргане.СоздатьМенеджерЗаписи();
		Запись.Организация = Выборка.Организация;
		Запись.Подразделение = Выборка.Подразделение;
		
		Запись.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

// Формирует временную таблицу, содержащую данные подразделений на дату документа:
// 	* Подразделение
// 	* Организация
// 	* РегистрацияВНалоговомОргане
//
//	Параметры:
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу ТаблицаДанныхДокументов с полями:
//		Ссылка,
//		Организация,
//		Подразделение,
//		Период.
//
Процедура ПоместитьВременнуюТаблицуДанныеПодразделений(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДанныхДокументов.Ссылка КАК Ссылка,
		|	ДанныеРегистрацийОрганизаций.Подразделение КАК Подразделение,
		|	ДанныеРегистрацийОрганизаций.Организация КАК Организация,
		|	МАКСИМУМ(ДанныеРегистрацийОрганизаций.Период) КАК Период
		|ПОМЕСТИТЬ МаксимумыДанныхПодразделений
		|ИЗ
		|	РегистрСведений.РегистрацииВНалоговомОргане КАК ДанныеРегистрацийОрганизаций
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ТаблицаДанныхДокументов
		|		ПО ДанныеРегистрацийОрганизаций.Подразделение = ТаблицаДанныхДокументов.Подразделение
		|		И ДанныеРегистрацийОрганизаций.Организация = ТаблицаДанныхДокументов.Организация
		|		И ДанныеРегистрацийОрганизаций.Период <= ТаблицаДанныхДокументов.Период
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|		ПО ДанныеРегистрацийОрганизаций.РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Ссылка
		|		И (РегистрацииВНалоговомОргане.ДатаСнятияСУчета > ДанныеРегистрацийОрганизаций.Период
		|		ИЛИ РегистрацииВНалоговомОргане.ДатаСнятияСУчета = ДАТАВРЕМЯ(1, 1, 1))
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДанныхДокументов.Ссылка,
		|	ДанныеРегистрацийОрганизаций.Подразделение,
		|	ДанныеРегистрацийОрганизаций.Организация
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Подразделение,
		|	Организация,
		|	Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДанныхДокументов.Ссылка КАК Ссылка,
		|	ДанныеРегистрацийОрганизаций.Организация КАК Организация,
		|	МАКСИМУМ(ДанныеРегистрацийОрганизаций.Период) КАК Период
		|ПОМЕСТИТЬ МаксимумыДанныхОрганизаций
		|ИЗ
		|	РегистрСведений.РегистрацииВНалоговомОргане КАК ДанныеРегистрацийОрганизаций
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ТаблицаДанныхДокументов
		|		ПО ДанныеРегистрацийОрганизаций.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
		|		И ДанныеРегистрацийОрганизаций.Организация = ТаблицаДанныхДокументов.Организация
		|		И ДанныеРегистрацийОрганизаций.Период <= ТаблицаДанныхДокументов.Период
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|		ПО ДанныеРегистрацийОрганизаций.РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Ссылка
		|		И (РегистрацииВНалоговомОргане.ДатаСнятияСУчета > ДанныеРегистрацийОрганизаций.Период
		|		ИЛИ РегистрацииВНалоговомОргане.ДатаСнятияСУчета = ДАТАВРЕМЯ(1, 1, 1))
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаДанныхДокументов.Ссылка,
		|	ДанныеРегистрацийОрганизаций.Организация
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Организация,
		|	Период
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МаксимумыДанныхПодразделений.Ссылка КАК Ссылка,
		|	РегистрацииВНалоговомОргане.Подразделение КАК Подразделение,
		|	РегистрацииВНалоговомОргане.Организация КАК Организация,
		|	РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
		|ПОМЕСТИТЬ ДанныеПодразделений
		|ИЗ
		|	РегистрСведений.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимумыДанныхПодразделений КАК МаксимумыДанныхПодразделений
		|		ПО (РегистрацииВНалоговомОргане.Подразделение = МаксимумыДанныхПодразделений.Подразделение
		|		И РегистрацииВНалоговомОргане.Организация = МаксимумыДанныхПодразделений.Организация
		|		И РегистрацииВНалоговомОргане.Период = МаксимумыДанныхПодразделений.Период)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка,
		|	Подразделение,
		|	Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МаксимумыДанныхОрганизаций.Ссылка КАК Ссылка,
		|	РегистрацииВНалоговомОргане.Организация КАК Организация,
		|	РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане
		|ПОМЕСТИТЬ ДанныеОрганизаций
		|ИЗ
		|	РегистрСведений.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимумыДанныхОрганизаций КАК МаксимумыДанныхОрганизаций
		|		ПО (РегистрацииВНалоговомОргане.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
		|		И РегистрацииВНалоговомОргане.Организация = МаксимумыДанныхОрганизаций.Организация
		|		И РегистрацииВНалоговомОргане.Период = МаксимумыДанныхОрганизаций.Период)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка,
		|	Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ МаксимумыДанныхПодразделений
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ МаксимумыДанныхОрганизаций
		|";
	
	РезультатЗапроса = Запрос.Выполнить();
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти




#КонецОбласти

#КонецЕсли
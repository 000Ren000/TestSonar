﻿
#Область ПрограммныйИнтерфейс

// Определяет следующие свойств регламентных заданий:
//  - зависимость от функциональных опций.
//  - возможность выполнения в различных режимах работы программы.
//  - прочие параметры.
//
// см. РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	//++ Локализация
	
	
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбменССайтом;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПроверкаКонтрагентов;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СборИОтправкаСтатистики;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалют;
	Настройка.РаботаетСВнешнимиРесурсами = Ложь;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ПолучениеДанныхСмартвей;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьИнтеграциюСоСмартвей;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	// ОбменДанными
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СинхронизацияДанных;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.СинхронизацияДанныхСПриложениемВИнтернете;
	Настройка.РаботаетСВнешнимиРесурсами = Истина;
	// Конец ОбменДанными
	
	//ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	//Конец ЭлектронноеВзаимодействие
	
	
	Настройка = Настройки.Добавить();
	Настройка.РегламентноеЗадание = Метаданные.РегламентныеЗадания.ОбновлениеСтатусовСертификатовНоменклатурыРосаккредитации;
	Настройка.ФункциональнаяОпция = Метаданные.ФункциональныеОпции.ИспользоватьСертификатыНоменклатуры;
	Настройка.ВключатьПриВключенииФункциональнойОпции = Ложь;
	
	ИнтеграцияГИСМ.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияЕГАИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияВЕТИС.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияИСМП.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияЗЕРНО.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	ИнтеграцияСАТУРН.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	

	// РаспознаваниеДокументов
	РаспознаваниеДокументов.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	// Конец РаспознаваниеДокументов
	
	// ИнтеграцияСМаркетплейсами
	ИнтеграцияСМаркетплейсамиСервер.ПриОпределенииНастроекРегламентныхЗаданий(Настройки);
	// Конец ИнтеграцияСМаркетплейсами
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
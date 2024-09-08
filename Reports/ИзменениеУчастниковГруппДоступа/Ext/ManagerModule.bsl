﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов")
	 Или Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом")
	 Или Не ПравоДоступа("Просмотр", Метаданные.Отчеты.ИзменениеУчастниковГруппДоступа)
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеДоступомСлужебный = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомСлужебный");
	ПараметрыДляОтчетов = МодульУправлениеДоступомСлужебный.ПараметрыДляОтчетов();
	
	Если Параметры.ИмяФормы <> "Справочник.Пользователи.Форма.ФормаСписка"
	   И Параметры.ИмяФормы <> "Справочник.Пользователи.Форма.ФормаЭлемента"
	   И Параметры.ИмяФормы <> "Справочник.ВнешниеПользователи.Форма.ФормаСписка"
	   И Параметры.ИмяФормы <> "Справочник.ВнешниеПользователи.Форма.ФормаЭлемента"
	   И Параметры.ИмяФормы <> ПараметрыДляОтчетов.ПолноеИмяФормыСпискаГруппДоступа
	   И Параметры.ИмяФормы <> ПараметрыДляОтчетов.ПолноеИмяФормыЭлементаГруппДоступа
	   И Параметры.ИмяФормы <> ПараметрыДляОтчетов.ПолноеИмяФормыСпискаПрофилей
	   И Параметры.ИмяФормы <> ПараметрыДляОтчетов.ПолноеИмяФормыЭлементаПрофилей Тогда
		Возврат;
	КонецЕсли;
	
	Команда = КомандыОтчетов.Добавить();
	Команда.Представление = НСтр("ru = 'Изменение участников групп доступа'");
	Команда.Менеджер = "Отчет.ИзменениеУчастниковГруппДоступа";
	Команда.КлючВарианта = "Основной";
	Команда.ТолькоВоВсехДействиях = Истина;
	Команда.Важность = "СмТакже";
	
КонецПроцедуры

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	НастройкиОтчета.ГруппироватьПоОтчету = Ложь;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Включен = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Выводит изменения участников групп доступа с учетом изменения групп пользователей за указанный период по событиям журнала регистрации.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли

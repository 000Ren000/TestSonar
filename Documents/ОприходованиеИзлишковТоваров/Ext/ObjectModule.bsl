﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует параметры заполнения видов запасов дополнительных свойств документа, используемых при записи документа
// в режиме 'Проведения' или 'Отмены проведения'.
//
// Параметры:
//	ДокументОбъект - ДокументОбъект.ОприходованиеИзлишковТоваров - документ, для которого выполняется инициализация параметров.
//	РежимЗаписи - РежимЗаписиДокумента - режим записи документа.
//
Процедура ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ДокументОбъект, РежимЗаписи = Неопределено) Экспорт
	
	ПараметрыЗаполненияВидовЗапасов = ЗапасыСервер.ПараметрыЗаполненияВидовЗапасов();
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("ПараметрыЗаполненияВидовЗапасов", ПараметрыЗаполненияВидовЗапасов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	ИнициализироватьДокумент();
	
	ПараметрыПолученияКоэффициентаРНПТ = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
											ЭтотОбъект);
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПолученияКоэффициентаРНПТ,
																					Товары);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары");
	
	ОприходованиеИзлишковТоваровЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДополнительныеСвойства.Вставить("ЗаполнитьТабличнуюЧастьТовары", Истина);
	ДокументОснование = Неопределено;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("АктОРасхождениях") 
			И ДанныеЗаполнения.Свойство("ОснованиеАкта") Тогда
			
			Если ТипЗнч(ДанныеЗаполнения.АктОРасхождениях) = Тип("ДокументСсылка.АктОРасхожденияхПослеПриемки") Тогда
				ЗаполнитьДокументНаОснованииАктаПриемки(ДанныеЗаполнения);
			ИначеЕсли ТипЗнч(ДанныеЗаполнения.АктОРасхождениях) = Тип("ДокументСсылка.АктОРасхожденияхПослеПеремещения") Тогда
				ЗаполнитьДокументНаОснованииАктаПеремещения(ДанныеЗаполнения);
			КонецЕсли;
			
			ДополнительныеСвойства.ЗаполнитьТабличнуюЧастьТовары = Ложь;
			ДокументОснование = ДанныеЗаполнения.АктОРасхождениях;
			
		ИначеЕсли ДанныеЗаполнения.Свойство("ПомощникИсправленияОстатковТоваровОрганизаций") Тогда
			
			ЗаполнитьДокументПоДаннымПомощникаИсправления(ДанныеЗаполнения);
			ДополнительныеСвойства.ЗаполнитьТабличнуюЧастьТовары = Ложь;
			
		ИначеЕсли Документы.СверкаНачальныхОстатковПоСкладу.ЗаполнитьОприходованиеИзлишковТоваровНаОснованииСверки(ЭтотОбъект, ДанныеЗаполнения) Тогда
			
			ДополнительныеСвойства.ЗаполнитьТабличнуюЧастьТовары = Ложь;
			
		Иначе
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			ДополнительныеСвойства.ЗаполнитьТабличнуюЧастьТовары = НЕ ДанныеЗаполнения.Свойство("НеЗаполнятьТаблинуюЧастьТовары");
			
		КонецЕсли;
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОприходованиеИзлишковТоваров") Тогда
		
		ДополнительныеСвойства.ЗаполнитьТабличнуюЧастьТовары = Ложь;
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(ТипЗнч(ДанныеЗаполнения))
		И ДанныеЗаполнения <> Неопределено Тогда
	
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПересчетТоваров") Тогда 
			СтруктураРезультат = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Статус, Склад");
			Если СтруктураРезультат.Статус <> Перечисления.СтатусыПересчетовТоваров.Выполнено Тогда 
				ТекстСообщения = НСтр("ru='Документ ""%ДокументПересчет%"" находится в статусе ""%СтатусПересчета%"". Ввод документа ""%ДокументАкт%"" на основании разрешен только в статусе ""%СтатусВыполнено%"".'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументПересчет%", ДанныеЗаполнения);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументАкт%", Метаданные.Документы.ОприходованиеИзлишковТоваров.Синоним);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусВыполнено%", Перечисления.СтатусыПересчетовТоваров.Выполнено);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтатусПересчета%", СтруктураРезультат.Статус);
				ВызватьИсключение ТекстСообщения;
			КонецЕсли;
			Склад = СтруктураРезультат.Склад;
			ПересчетТоваров = ДанныеЗаполнения;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Склад) И ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", ДанныеЗаполнения.Метаданные()) Тогда
			Склад = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "Склад");
		КонецЕсли;
		
		ДокументОснование = ДанныеЗаполнения;
	
	КонецЕсли;
	
	ОприходованиеИзлишковТоваровЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОприходованиеИзлишковТоваров.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ДополнительныеСвойства.ЗаполнитьТабличнуюЧастьТовары Тогда
		ЗаполнитьТабличнуюЧастьТовары(ДокументОснование);
	КонецЕсли;
	
	ДополнительныеСвойства.Удалить("ЗаполнитьТабличнуюЧастьТовары");
	
	ПараметрыПолученияКоэффициентаРНПТ = УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ПараметрыПолученияКоэффициентаРНПТ(
											ЭтотОбъект);
	УчетПрослеживаемыхТоваровЛокализация.ЗаполнитьКоличествоПоРНПТВТабличнойЧасти(ПараметрыПолученияКоэффициентаРНПТ,
																					Товары);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект,
	НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОприходованиеИзлишковТоваров));
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Перечисления.ХозяйственныеОперации.ОприходованиеТоваров, Склад, Подразделение, Неопределено);
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);
		
		ЗаполнитьВидыЗапасовДокумента();
		
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары");
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОприходованиеИзлишковТоваров.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОприходованиеИзлишковТоваровЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ОприходованиеИзлишковТоваров),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоРНПТ");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерГТД");
	
	ЭтоПрослеживаемыйДокумент = УчетПрослеживаемыхТоваровЛокализация.ЭтоПрослеживаемыйДокумент(Товары, Дата);
	
	Если ЭтоПрослеживаемыйДокумент
		Или ПолучитьФункциональнуюОпцию("ЗапретитьПоступлениеТоваровБезНомеровГТД") Тогда
		
		ЗапасыСервер.ПроверитьЗаполнениеНомеровГТД(ЭтотОбъект, Отказ);
		
	КонецЕсли;
	
	Если ЭтоПрослеживаемыйДокумент Тогда
		УчетПрослеживаемыхТоваровЛокализация.ПроверитьКорректностьНастроекТоваровРНПТ(ЭтотОбъект, Товары, Дата);
	КонецЕсли;
	
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Выбор статей и аналитик.
	ПараметрыВыбораСтатейИАналитик = Документы.ОприходованиеИзлишковТоваров.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты,
		ПараметрыВыбораСтатейИАналитик);
	
	ОприходованиеИзлишковТоваровЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ИнициализироватьПараметрыЗаполненияВидовЗапасовДляПроведения(ЭтотОбъект);
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОприходованиеИзлишковТоваровЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьТабличнуюЧастьТовары(ДокументОснование = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Склад);
	
	Если ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда 
		
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ПересчетТоваров") Тогда
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТоварыОснования.Регистратор				КАК Ссылка,
			|	ТоварыОснования.Номенклатура			КАК Номенклатура,
			|	ТоварыОснования.Характеристика			КАК Характеристика,
			|	ТоварыОснования.Назначение				КАК Назначение,
			|	ТоварыОснования.Серия					КАК Серия,
			|	СУММА(ТоварыОснования.КОформлениюАктов)	КАК Количество
			|ПОМЕСТИТЬ ТоварыОснованияКОформлению
			|ИЗ
			|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыОснования
			|
			|ГДЕ
			|	ТоварыОснования.Активность
			|	И ТоварыОснования.Регистратор = &ДокументОснование
			|	И ТоварыОснования.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
			|
			|СГРУППИРОВАТЬ ПО
			|	ТоварыОснования.Регистратор,
			|	ТоварыОснования.Номенклатура,
			|	ТоварыОснования.Характеристика,
			|	ТоварыОснования.Назначение,
			|	ТоварыОснования.Серия
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Ссылка,
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия
			|;
			|
			|//////////////////////////////////////////////////////////////////////////////// 1
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ОформленныеДокументы.Ссылка КАК Ссылка
			|ПОМЕСТИТЬ ОформленныеДокументы
			|ИЗ
			|	Документ.ОприходованиеИзлишковТоваров.Товары КАК ОформленныеТовары
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОприходованиеИзлишковТоваров КАК ОформленныеДокументы
			|		ПО ОформленныеТовары.Ссылка = ОформленныеДокументы.Ссылка
			|
			|ГДЕ
			|	ОформленныеДокументы.Проведен
			|	И ОформленныеДокументы.Ссылка <> &ТекущийДокумент
			|	И (ОформленныеДокументы.ПересчетТоваров, ОформленныеТовары.Номенклатура, ОформленныеТовары.Характеристика,
			|		ОформленныеТовары.Назначение, ОформленныеТовары.Серия) В
			|			(ВЫБРАТЬ
			|				ТоварыКОформлению.Ссылка			КАК Ссылка,
			|				ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|				ТоварыКОформлению.Характеристика	КАК Характеристика,
			|				ТоварыКОформлению.Назначение		КАК Назначение,
			|				ТоварыКОформлению.Серия				КАК Серия
			|			ИЗ
			|				ТоварыОснованияКОформлению КАК ТоварыКОформлению)
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Ссылка
			|;
			|
			|//////////////////////////////////////////////////////////////////////////////// 2
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ОформленныеТовары.Номенклатура					КАК Номенклатура,
			|	ОформленныеТовары.Характеристика				КАК Характеристика,
			|	ОформленныеТовары.Назначение					КАК Назначение,
			|	ОформленныеТовары.Серия							КАК Серия,
			|	СУММА(ОформленныеТовары.КОформлениюАктовРасход)	КАК Количество
			|ПОМЕСТИТЬ ОформленныеТовары
			|ИЗ
			|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Обороты(,
			|			,
			|			Регистратор,
			|			Склад = &Склад
			|				И (Номенклатура, Характеристика, Назначение, Серия) В
			|						(ВЫБРАТЬ
			|							ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|							ТоварыКОформлению.Характеристика	КАК Характеристика,
			|							ТоварыКОформлению.Назначение		КАК Назначение,
			|							ТоварыКОформлению.Серия				КАК Серия
			|						ИЗ
			|							ТоварыОснованияКОформлению КАК ТоварыКОформлению)
			|	
			|	) КАК ОформленныеТовары
			|
			|ГДЕ
			|	ОформленныеТовары.Регистратор В
			|			(ВЫБРАТЬ
			|				ОформленныеДокументы.Ссылка КАК Ссылка
			|			ИЗ
			|				ОформленныеДокументы КАК ОформленныеДокументы)
			|
			|СГРУППИРОВАТЬ ПО
			|	ОформленныеТовары.Номенклатура,
			|	ОформленныеТовары.Характеристика,
			|	ОформленныеТовары.Назначение,
			|	ОформленныеТовары.Серия
			|
			|ИМЕЮЩИЕ
			|	СУММА(ОформленныеТовары.КОформлениюАктовРасход) > 0
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия
			|;
			|
			|//////////////////////////////////////////////////////////////////////////////// 3
			|ВЫБРАТЬ
			|	ТоварыОснования.Номенклатура	КАК Номенклатура,
			|	ТоварыОснования.Характеристика	КАК Характеристика,
			|	ТоварыОснования.Назначение		КАК Назначение,
			|	ТоварыОснования.Серия			КАК Серия,
			|	ТоварыОснования.Количество - ЕСТЬNULL(ОформленныеТовары.Количество, 0) КАК Количество
			|ПОМЕСТИТЬ ОстатокТоваровКОформлению
			|ИЗ
			|	ТоварыОснованияКОформлению КАК ТоварыОснования
			|		ЛЕВОЕ СОЕДИНЕНИЕ ОформленныеТовары КАК ОформленныеТовары
			|		ПО ТоварыОснования.Номенклатура = ОформленныеТовары.Номенклатура
			|			И ТоварыОснования.Характеристика = ОформленныеТовары.Характеристика
			|			И ТоварыОснования.Назначение = ОформленныеТовары.Назначение
			|			И ТоварыОснования.Серия = ОформленныеТовары.Серия
			|
			|ГДЕ
			|	ТоварыОснования.Количество - ЕСТЬNULL(ОформленныеТовары.Количество, 0) > 0
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия
			|;
			|
			|//////////////////////////////////////////////////////////////////////////////// 4
			|ВЫБРАТЬ
			|	ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|	ТоварыКОформлению.Характеристика	КАК Характеристика,
			|	ТоварыКОформлению.Назначение		КАК Назначение,
			|	ТоварыКОформлению.Серия				КАК Серия,
			|	СУММА(ТоварыКОформлению.Количество)	КАК Количество
			|ПОМЕСТИТЬ ТоварыКОформлению
			|ИЗ
			|	(ВЫБРАТЬ
			|		ТоварыКОформлению.Номенклатура				КАК Номенклатура,
			|		ТоварыКОформлению.Характеристика			КАК Характеристика,
			|		ТоварыКОформлению.Назначение				КАК Назначение,
			|		ТоварыКОформлению.Серия						КАК Серия,
			|		ТоварыКОформлению.КОформлениюАктовОстаток	КАК Количество
			|	ИЗ
			|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(,
			|				Склад = &Склад
			|					И (Номенклатура, Характеристика, Назначение, Серия) В
			|							(ВЫБРАТЬ
			|								ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|								ТоварыКОформлению.Характеристика	КАК Характеристика,
			|								ТоварыКОформлению.Назначение		КАК Назначение,
			|								ТоварыКОформлению.Серия				КАК Серия
			|							ИЗ
			|								ОстатокТоваровКОформлению КАК ТоварыКОформлению)) КАК ТоварыКОформлению
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|		ТоварыКОформлению.Характеристика	КАК Характеристика,
			|		ТоварыКОформлению.Назначение		КАК Назначение,
			|		ТоварыКОформлению.Серия				КАК Серия,
			|		ТоварыКОформлению.КОформлениюАктов	КАК Количество
			|	ИЗ
			|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыКОформлению
			|	
			|	ГДЕ
			|		ТоварыКОформлению.Активность
			|		И ТоварыКОформлению.Регистратор = &ТекущийДокумент) КАК ТоварыКОформлению
			|
			|СГРУППИРОВАТЬ ПО
			|	ТоварыКОформлению.Номенклатура,
			|	ТоварыКОформлению.Характеристика,
			|	ТоварыКОформлению.Назначение,
			|	ТоварыКОформлению.Серия
			|
			|ИМЕЮЩИЕ
			|	СУММА(ТоварыКОформлению.Количество) > 0
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия
			|;
			|
			|//////////////////////////////////////////////////////////////////////////////// 5
			|ВЫБРАТЬ
			|	ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|	ТоварыКОформлению.Характеристика	КАК Характеристика,
			|	ТоварыКОформлению.Серия				КАК Серия,
			|	ТоварыКОформлению.Назначение		КАК Назначение,
			|	ВЫБОР
			|		КОГДА ТоварыКОформлению.Количество > ОстатокТоваровКОформлению.Количество
			|			ТОГДА ОстатокТоваровКОформлению.Количество
			|		ИНАЧЕ ТоварыКОформлению.Количество
			|	КОНЕЦ								КАК Количество
			|ИЗ
			|	ТоварыКОформлению КАК ТоварыКОформлению
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОстатокТоваровКОформлению КАК ОстатокТоваровКОформлению
			|		ПО ТоварыКОформлению.Номенклатура = ОстатокТоваровКОформлению.Номенклатура
			|			И ТоварыКОформлению.Характеристика = ОстатокТоваровКОформлению.Характеристика
			|			И ТоварыКОформлению.Назначение = ОстатокТоваровКОформлению.Назначение
			|			И ТоварыКОформлению.Серия = ОстатокТоваровКОформлению.Серия";
			
		Иначе
			
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|	ТоварыКОформлению.Характеристика	КАК Характеристика,
			|	ТоварыКОформлению.Назначение		КАК Назначение,
			|	ТоварыКОформлению.Серия				КАК Серия,
			|	СУММА(ТоварыКОформлению.Количество)	КАК Количество
			|ПОМЕСТИТЬ ТоварыКОформлению
			|ИЗ
			|	(ВЫБРАТЬ
			|		ТоварыКОформлению.Номенклатура				КАК Номенклатура,
			|		ТоварыКОформлению.Характеристика			КАК Характеристика,
			|		ТоварыКОформлению.Назначение				КАК Назначение,
			|		ТоварыКОформлению.Серия						КАК Серия,
			|		ТоварыКОформлению.КОформлениюАктовОстаток	КАК Количество
			|	ИЗ
			|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(, Склад = &Склад) КАК ТоварыКОформлению
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|		ТоварыКОформлению.Характеристика	КАК Характеристика,
			|		ТоварыКОформлению.Назначение		КАК Назначение,
			|		ТоварыКОформлению.Серия				КАК Серия,
			|		ТоварыКОформлению.КОформлениюАктов	КАК Количество
			|	ИЗ
			|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыКОформлению
			|	
			|	ГДЕ
			|		ТоварыКОформлению.Активность
			|		И ТоварыКОформлению.Регистратор = &ТекущийДокумент) КАК ТоварыКОформлению
			|
			|СГРУППИРОВАТЬ ПО
			|	ТоварыКОформлению.Номенклатура,
			|	ТоварыКОформлению.Характеристика,
			|	ТоварыКОформлению.Назначение,
			|	ТоварыКОформлению.Серия
			|
			|ИМЕЮЩИЕ
			|	СУММА(ТоварыКОформлению.Количество) > 0
			|
			|ИНДЕКСИРОВАТЬ ПО
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия
			|;
			|
			|//////////////////////////////////////////////////////////////////////////////// 1
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТоварыКОформлению.Номенклатура		КАК Номенклатура,
			|	ТоварыКОформлению.Характеристика	КАК Характеристика,
			|	ТоварыКОформлению.Серия				КАК Серия,
			|	ТоварыКОформлению.Назначение		КАК Назначение,
			|	ТоварыКОформлению.Количество		КАК Количество
			|ИЗ
			|	ТоварыКОформлению КАК ТоварыКОформлению
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюИзлишковНедостач КАК ТоварыОснования
			|		ПО ТоварыОснования.Активность
			|			И ТоварыОснования.Регистратор = &ДокументОснование
			|			И ТоварыКОформлению.Номенклатура = ТоварыОснования.Номенклатура
			|			И ТоварыКОформлению.Характеристика = ТоварыОснования.Характеристика
			|			И ТоварыКОформлению.Назначение = ТоварыОснования.Назначение
			|			И ТоварыКОформлению.Серия = ТоварыОснования.Серия
			|
			|ГДЕ
			|	НЕ ТоварыОснования.Номенклатура ЕСТЬ NULL";
			
		КонецЕсли;
		
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
	Иначе
		
		// На неордерном складе ДокументОснование будет только пересчет
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварыПересчета.Номенклатура	КАК Номенклатура,
		|	ТоварыПересчета.Характеристика	КАК Характеристика,
		|	ТоварыПересчета.Серия			КАК Серия,
		|	ТоварыПересчета.Назначение		КАК Назначение,
		|	СУММА(ТоварыПересчета.КоличествоФакт - ТоварыПересчета.Количество)	КАК Количество
		|ИЗ
		|	Документ.ПересчетТоваров.Товары КАК ТоварыПересчета
		|
		|ГДЕ
		|	ТоварыПересчета.Ссылка = &ДокументОснование
		|
		|СГРУППИРОВАТЬ ПО
		|	ТоварыПересчета.Номенклатура,
		|	ТоварыПересчета.Характеристика,
		|	ТоварыПересчета.Назначение,
		|	ТоварыПересчета.Серия
		|
		|ИМЕЮЩИЕ
		|	СУММА(ТоварыПересчета.КоличествоФакт - ТоварыПересчета.Количество) > 0";
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
		Если ЗначениеЗаполнено(ВидЦены) Тогда
			КолонкиПоЗначению = Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
			
			ПараметрыЗаполнения	= Новый Структура;
			ПараметрыЗаполнения.Вставить("Дата",				Дата);
			ПараметрыЗаполнения.Вставить("Организация",			Организация);
			ПараметрыЗаполнения.Вставить("Валюта",				Валюта);
			ПараметрыЗаполнения.Вставить("ВидЦены",				ВидЦены);
			ПараметрыЗаполнения.Вставить("КолонкиПоЗначению",	КолонкиПоЗначению);
			
			СтруктураДействий = Новый Структура("ПересчитатьСумму", "Количество");
			
			ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(Товары, Неопределено, ПараметрыЗаполнения, СтруктураДействий);
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДокументОснование) Тогда
		
		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить оприходование.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДокументОснование);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Автор         = Пользователи.ТекущийПользователь();
	Ответственный = Пользователи.ТекущийПользователь();
	Организация   = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Склад         = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = Справочники.Склады.УчетныйВидЦены(Склад);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(
			Справочники.ВидыЦен.ПолучитьРеквизитыВидаЦены(ВидЦены).ВалютаЦены);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) И ТипЗнч(Основание) = Тип("ДокументСсылка.СверкаНачальныхОстатковПоСкладу") Тогда
		Основание = Неопределено;
	КонецЕсли;
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииАктаПриемки(ДанныеЗаполнения);
	
	ТипАктаПриемка = ТипАктаОРасхожденияхПриемка(ДанныеЗаполнения.АктОРасхождениях);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемки.Организация КАК Организация,
	|	АктОРасхожденияхПослеПриемки.Менеджер КАК Ответственный,
	|	АктОРасхожденияхПослеПриемки.Подразделение КАК Подразделение,
	|	&Склад КАК Склад,
	|	&Основание КАК Основание
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки КАК АктОРасхожденияхПослеПриемки
	|ГДЕ
	|	АктОРасхожденияхПослеПриемки.Ссылка = &АктОРасхождениях
	|;";
	
	Запрос.УстановитьПараметр("АктОРасхождениях", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад",            ДанныеЗаполнения.Склад);
	
	Если ТипАктаПриемка Тогда
		Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.АктОРасхождениях);
	Иначе
		Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	КонецЕсли;
	
	// Заполнение ТЧ
	
	Запрос.Текст =  "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемкиТовары.Номенклатура,
	|	АктОРасхожденияхПослеПриемкиТовары.Характеристика,
	|	АктОРасхожденияхПослеПриемкиТовары.Назначение,
	|	АктОРасхожденияхПослеПриемкиТовары.Количество - АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу КАК Количество,
	|	АктОРасхожденияхПослеПриемкиТовары.Серия,
	|	АктОРасхожденияхПослеПриемкиТовары.СтатусУказанияСерий,
	|	АктОРасхожденияхПослеПриемкиТовары.Цена КАК Цена,
	|	АктОРасхожденияхПослеПриемкиТовары.НомерГТД КАК НомерГТД,
	|	АктОРасхожденияхПослеПриемкиТовары.Сумма - АктОРасхожденияхПослеПриемкиТовары.СуммаПоДокументу КАК Сумма
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки.Товары КАК АктОРасхожденияхПослеПриемкиТовары
	|ГДЕ
	|	АктОРасхожденияхПослеПриемкиТовары.Ссылка = &Ссылка
	|	И (АктОРасхожденияхПослеПриемкиТовары.ДокументОснование = &Основание
	|		ИЛИ &ТипАктаПриемка)
	|	И АктОРасхожденияхПослеПриемкиТовары.Количество - АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу > 0
	|	И АктОРасхожденияхПослеПриемкиТовары.Склад = &Склад
	|	И АктОРасхожденияхПослеПриемкиТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиПерепоставленноеНаПрочиеДоходы)
	|
	|УПОРЯДОЧИТЬ ПО
	|	АктОРасхожденияхПослеПриемкиТовары.НомерСтроки";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад", ДанныеЗаполнения.Склад);
	Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	Запрос.УстановитьПараметр("ТипАктаПриемка", ТипАктаПриемка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
		Если ЗначениеЗаполнено(ВидЦены) И Товары.Количество() > 0 Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			КолонкиПоЗначению = Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
			
			ПараметрыЗаполнения.Вставить("Дата",				Дата);
			ПараметрыЗаполнения.Вставить("Организация",			Организация);
			ПараметрыЗаполнения.Вставить("Валюта",				Валюта);
			ПараметрыЗаполнения.Вставить("ВидЦены",				ВидЦены);
			ПараметрыЗаполнения.Вставить("КолонкиПоЗначению",	КолонкиПоЗначению);
			
			СтруктураДействий = Новый Структура("ПересчитатьСумму", "Количество");
			
			ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
				Товары,,
				ПараметрыЗаполнения, 
				СтруктураДействий);
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.АктОРасхождениях) Тогда  
		
		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить оприходование.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДанныеЗаполнения.АктОРасхождениях);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииАктаПеремещения(ДанныеЗаполнения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемки.Организация КАК Организация,
	|	АктОРасхожденияхПослеПриемки.Менеджер КАК Ответственный,
	|	АктОРасхожденияхПослеПриемки.Подразделение КАК Подразделение,
	|	&Склад КАК Склад,
	|	&Основание КАК Основание
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПеремещения КАК АктОРасхожденияхПослеПриемки
	|ГДЕ
	|	АктОРасхожденияхПослеПриемки.Ссылка = &АктОРасхождениях
	|;";
	
	Запрос.УстановитьПараметр("АктОРасхождениях", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад",            ДанныеЗаполнения.Склад);
	
	Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ВыборкаШапка = РезультатЗапроса.Выбрать();
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	КонецЕсли;
	
	// Заполнение ТЧ
	
	Запрос.Текст =  "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемкиТовары.Номенклатура,
	|	АктОРасхожденияхПослеПриемкиТовары.Характеристика,
	|	АктОРасхожденияхПослеПриемкиТовары.Назначение,
	|	АктОРасхожденияхПослеПриемкиТовары.Количество - АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу КАК Количество,
	|	АктОРасхожденияхПослеПриемкиТовары.Серия,
	|	АктОРасхожденияхПослеПриемкиТовары.СтатусУказанияСерий
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПеремещения.Товары КАК АктОРасхожденияхПослеПриемкиТовары
	|ГДЕ
	|	АктОРасхожденияхПослеПриемкиТовары.Ссылка = &Ссылка
	|	И АктОРасхожденияхПослеПриемкиТовары.ДокументОснование = &Основание
	|	И АктОРасхожденияхПослеПриемкиТовары.Количество - АктОРасхожденияхПослеПриемкиТовары.КоличествоПоДокументу > 0
	|	И АктОРасхожденияхПослеПриемкиТовары.Ссылка.СкладПолучатель = &Склад
	|	И АктОРасхожденияхПослеПриемкиТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПерепоставленноеДарится)
	|
	|УПОРЯДОЧИТЬ ПО
	|	АктОРасхожденияхПослеПриемкиТовары.НомерСтроки";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("Склад", ДанныеЗаполнения.Склад);
	Запрос.УстановитьПараметр("Основание", ДанныеЗаполнения.ОснованиеАкта);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не Результат.Пустой() Тогда
		
		Товары.Загрузить(Результат.Выгрузить());
		
		Если ЗначениеЗаполнено(ВидЦены) И Товары.Количество() > 0 Тогда
			
			ПараметрыЗаполнения = Новый Структура;
			КолонкиПоЗначению = Новый Структура("Упаковка", Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
			
			ПараметрыЗаполнения.Вставить("Дата",				Дата);
			ПараметрыЗаполнения.Вставить("Валюта",				Валюта);
			ПараметрыЗаполнения.Вставить("ВидЦены",				ВидЦены);
			ПараметрыЗаполнения.Вставить("КолонкиПоЗначению",	КолонкиПоЗначению);
			
			СтруктураДействий = Новый Структура("ПересчитатьСумму", "Количество");
			
			ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
				Товары,,
				ПараметрыЗаполнения, 
				СтруктураДействий);
			
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(ДанныеЗаполнения.АктОРасхождениях) Тогда  
		
		ТекстСообщения = НСтр("ru = 'В документе ""%ДокументОснование%"" отсутствуют товары, по которым необходимо оформить оприходование.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДокументОснование%", ДанныеЗаполнения.АктОРасхождениях);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоДаннымПомощникаИсправления(ДанныеЗаполнения)
	
	Дата = ДанныеЗаполнения.Дата;
	Для Каждого Стр Из ДанныеЗаполнения.Товары Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), Стр);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВидыЗапасов

Процедура ЗаполнитьВидыЗапасовДокумента()
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.СверкаНачальныхОстатковПоСкладу") Тогда
		Возврат; // виды запасов заполнены по данным документа-основания
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ТаблицаТоваров.ВидЗапасов КАК ВидЗапасов
	|ПОМЕСТИТЬ ВтИсходнаяТаблицаТоваров
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|ГДЕ
	|	ТаблицаТоваров.ВидЗапасов = ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	ИЛИ &ПерезаполнитьВидыЗапасов
	|;
	|///////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТоваров.Номенклатура КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА &Проведен
	|			ТОГДА ТаблицаТоваров.ВидЗапасов
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ВидыЗапасов.ПустаяСсылка)
	|	КОНЕЦ КАК ТекущийВидЗапасов,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара,
	|	&Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОприходованиеТоваров) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.Товар) КАК ТипЗапасов,
	|	ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка) КАК Соглашение,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК Контрагент,
	|	ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка) КАК Договор,
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеНДС,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка) КАК НалогообложениеОрганизации,
	|	НЕОПРЕДЕЛЕНО КАК ВладелецТовара,
	|	ЗНАЧЕНИЕ(Справочник.ВидыЦенПоставщиков.ПустаяСсылка) КАК ВидЦены
	|ПОМЕСТИТЬ ИсходнаяТаблицаТоваров
	|ИЗ
	|	ВтИсходнаяТаблицаТоваров КАК ТаблицаТоваров
	|;
	|///////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВтИсходнаяТаблицаТоваров
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаТоваров", Товары.Выгрузить(, "НомерСтроки, Номенклатура, ВидЗапасов"));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Проведен", Проведен);
	
	ЗапасыСервер.ДополнитьВременныеТаблицыОбязательнымиКолонками(Запрос);
	ЗапасыСервер.ПроверитьНеобходимостьПерезаполненияВидовЗапасовДокумента(ЭтотОбъект, Запрос);
	
	Запрос.Выполнить();
	
	ЗапасыСервер.ЗаполнитьВидыЗапасовПоУмолчанию(МенеджерВременныхТаблиц, Товары);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ТипАктаОРасхожденияхПриемка(АктОРасхождениях)
	
	ТипОснованияАктаОРасхождении = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(АктОРасхождениях,
		"ТипОснованияАктаОРасхождении");
	
	ТипыОснованияАктаОРасхожденииПриемка = Новый Массив;
	ТипыОснованияАктаОРасхожденииПриемка.Добавить(Перечисления.ТипыОснованияАктаОРасхождении.ПриемкаТоваровНаХранение);
	
	Возврат ТипыОснованияАктаОРасхожденииПриемка.Найти(ТипОснованияАктаОРасхождении) <> Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

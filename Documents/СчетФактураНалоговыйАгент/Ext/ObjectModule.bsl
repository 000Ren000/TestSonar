﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
		
		РеквизитыЗаполнения = РеквизитыРасходныйКассовыйОрдер(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
		
		РеквизитыЗаполнения = РеквизитыСписаниеБезналичныхДенежныхСредств(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.КорректировкаЗадолженности") Тогда
		
		РеквизитыЗаполнения = РеквизитыКорректировкаЗадолженности(ДанныеЗаполнения);
		ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Договор") И ЗначениеЗаполнено(ДанныеЗаполнения.Договор) Тогда
			РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
				ДанныеЗаполнения.Договор, "НаправлениеДеятельности, Партнер");
				
			ДанныеЗаполнения.Вставить("Партнер", РеквизитыДоговора.Партнер);
			ДанныеЗаполнения.Вставить("НаправлениеДеятельности", РеквизитыДоговора.НаправлениеДеятельности);
		КонецЕсли;
		
		ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения);
		
	КонецЕсли;

	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	// Проверим время документа относительно времени документа-основания
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ДатаДокументаОснования = ДокументОснование.Дата;
		Если НачалоДня(Дата) = НачалоДня(ДатаДокументаОснования) ИЛИ НЕ ЗначениеЗаполнено(Дата) Тогда
		 	
			Дата = ?(ДатаДокументаОснования = КонецДня(ДатаДокументаОснования),
					 ДатаДокументаОснования,
					 ДатаДокументаОснования + 1);
			
		КонецЕсли; 
		
		СформироватьСтрокуРасчетноПлатежныхДокументов();
	
	КонецЕсли; 
	
	Сумма = РасшифровкаСуммы.Итог("Сумма");
	СуммаСНДС = РасшифровкаСуммы.Итог("СуммаСНДС");
	СуммаНДС = РасшифровкаСуммы.Итог("СуммаНДС");
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, Метаданные().ТабличныеЧасти.РасшифровкаСуммы.Имя);
	
	Если Не ПометкаУдаления Тогда
		ПроверитьДублиСчетФактуры(Отказ);
	КонецЕсли;
	
	
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		РучнаяКорректировкаЖурналаСФ = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если НЕ Отказ Тогда
		МассивДокументов= Новый Массив;
		МассивДокументов.Добавить(Ссылка);
		УчетНДСУП.СформироватьЗаданияПоДокументам(МассивДокументов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ЗарегистрироватьСчетаФактурыОжидаетОплатыНДС(Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(ДокументОснование) ИЛИ НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "Проведен") Тогда
		
		ТекстСообщения = НСтр("ru = 'Счет-фактуру можно провести только на основании проведенного документа.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			"ДокументОснование",
			, // ПутьКДанным 
			Отказ);
	
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Префикс = "0";
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СтавкаНДС = УчетНДСУП.СтавкаНДСПоУмолчанию(Организация, Дата, Истина);
	
	Для Каждого Строка Из РасшифровкаСуммы Цикл
		Строка.СтавкаНДС= СтавкаНДС;
	КонецЦикла;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Ложь);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(РасшифровкаСуммы, СтруктураДействий, Неопределено);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Функция РеквизитыКорректировкаЗадолженности(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КорректировкаЗадолженности.Дата КАК Дата,
	|	КорректировкаЗадолженности.Проведен КАК Проведен,
	|	КорректировкаЗадолженности.Ссылка КАК ДокументОснование,
	|	КорректировкаЗадолженности.Организация КАК Организация,
	|	КорректировкаЗадолженности.Контрагент КАК Поставщик,
	|	НЕОПРЕДЕЛЕНО КАК Подразделение,
	|	КорректировкаЗадолженности.ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.КорректировкаЗадолженности КАК КорректировкаЗадолженности
	|ГДЕ
	|	КорректировкаЗадолженности.Ссылка = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Функция РеквизитыРасходныйКассовыйОрдер(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Дата КАК Дата,
	|	РасходныйКассовыйОрдер.Проведен КАК Проведен,
	|	РасходныйКассовыйОрдер.Ссылка КАК ДокументОснование,
	|	РасходныйКассовыйОрдер.Организация КАК Организация,
	|	РасходныйКассовыйОрдер.Контрагент КАК Поставщик,
	|	РасходныйКассовыйОрдер.Подразделение КАК Подразделение,
	|	РасходныйКассовыйОрдер.ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.Ссылка = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Функция РеквизитыСписаниеБезналичныхДенежныхСредств(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписаниеБезналичныхДенежныхСредств.Дата КАК Дата,
	|	СписаниеБезналичныхДенежныхСредств.Проведен КАК Проведен,
	|	СписаниеБезналичныхДенежныхСредств.Ссылка КАК ДокументОснование,
	|	СписаниеБезналичныхДенежныхСредств.Организация КАК Организация,
	|	СписаниеБезналичныхДенежныхСредств.Контрагент КАК Поставщик,
	|	СписаниеБезналичныхДенежныхСредств.Подразделение КАК Подразделение,
	|	СписаниеБезналичныхДенежныхСредств.ХозяйственнаяОперация КАК ХозяйственнаяОперация
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК СписаниеБезналичныхДенежныхСредств
	|ГДЕ
	|	СписаниеБезналичныхДенежныхСредств.Ссылка = &Документ";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка;
	
КонецФункции

Процедура ЗаполнитьПоПлатежномуДокументу(РеквизитыЗаполнения)
	
	ОбщегоНазначенияУТ.ПроверитьВозможностьВводаНаОсновании(РеквизитыЗаполнения.ДокументОснование, , НЕ РеквизитыЗаполнения.Проведен);
	
	Если РеквизитыЗаполнения.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ОплатаПоставщику
		И РеквизитыЗаполнения.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ОплатаАрендодателю
		И РеквизитыЗаполнения.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности Тогда
		ТекстОшибки = НСтр("ru='Не требуется вводить счет-фактуру на основании документа %Документ%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Документ%", РеквизитыЗаполнения.ДокументОснование);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыЗаполнения,, "ХозяйственнаяОперация");
	
	ОтборРасчетов = Документы.СчетФактураНалоговыйАгент.ОтборРасчетов();
	ОтборРасчетов.Вставить("НачалоПериода", НачалоДня(Дата));
	ОтборРасчетов.Вставить("КонецПериода",  КонецМесяца(Дата));
	ОтборРасчетов.Вставить("СтавкаНДС",     УчетНДСУП.СтавкаНДСПоУмолчанию(Организация, Дата, Истина));
	ОтборРасчетов.Вставить("Организация",   Организация);
	ОтборРасчетов.Вставить("РасчетныйДокумент", РеквизитыЗаполнения.ДокументОснование);
	
	ВыплаченныеСуммы = Новый ТаблицаЗначений;;
	ВыплаченныеСуммы.Колонки.Добавить("СФСформирован");
	ВыплаченныеСуммы.Колонки.Добавить("СчетФактура");
	ВыплаченныеСуммы.Колонки.Добавить("Договор");
	ВыплаченныеСуммы.Колонки.Добавить("ВидАгентскогоДоговора");
	ВыплаченныеСуммы.Колонки.Добавить("НаправлениеДеятельности");
	ВыплаченныеСуммы.Колонки.Добавить("ЮрФизЛицо");
	ВыплаченныеСуммы.Колонки.Добавить("Сумма");
	ВыплаченныеСуммы.Колонки.Добавить("СтавкаНДС");
	ВыплаченныеСуммы.Колонки.Добавить("СуммаНДС");
	
	Документы.СчетФактураНалоговыйАгент.ЗаполнитьОплатыПоставщикам(ОтборРасчетов, ВыплаченныеСуммы);
	
	Если ВыплаченныеСуммы.Количество() Тогда
		Договор = ВыплаченныеСуммы[0].Договор;
		ВидАгентскогоДоговора = ВыплаченныеСуммы[0].ВидАгентскогоДоговора;
	КонецЕсли;
	
	ВыплаченныеСуммы.Свернуть("НаправлениеДеятельности,СтавкаНДС", "Сумма, СуммаНДС");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", Новый Структура("ЦенаВключаетНДС", Ложь));
	
	Для Каждого СтрокаВыплаченныеСуммы Из ВыплаченныеСуммы Цикл
		СтрокаДокумента = РасшифровкаСуммы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДокумента, СтрокаВыплаченныеСуммы);
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаДокумента, СтруктураДействий, Неопределено);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументуОснованию(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("ДокументОснование") И ЗначениеЗаполнено(ДанныеЗаполнения.ДокументОснование) Тогда
		
		Если ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.РасходныйКассовыйОрдер")
			ИЛИ ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.СписаниеБезналичныхДенежныхСредств") Тогда
			ДанныеЗаполнения.Вставить("Подразделение", ДанныеЗаполнения.ДокументОснование.Подразделение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("Ответственный") Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Подразделение") Тогда
		Подразделение = ДанныеЗаполнения.Подразделение;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Организация") Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(ДанныеЗаполнения.Организация);
	Иначе
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ПроверитьДублиСчетФактуры(Отказ)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеДокумента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.СчетФактураНалоговыйАгент КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка <> &Ссылка
	|	И ДанныеДокумента.ДокументОснование = &ДокументОснование
	|	И НЕ ДанныеДокумента.ПометкаУдаления
	|	И ДанныеДокумента.Договор = &Договор
	|	И (ДанныеДокумента.Организация = &Организация
	|			ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (Не ДанныеДокумента.ДокументОснование ССЫЛКА Документ.АвансовыйОтчет
	|			ИЛИ ДанныеДокумента.Поставщик = &Поставщик)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Поставщик", Поставщик);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		
		Если ЗначениеЗаполнено(Договор) Тогда
			Текст = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 по организации %2 и договору %3 уже введен счет-фактура %4'"),
					ДокументОснование,
					Организация,
					Договор,
					Выборка.Ссылка);
		Иначе
			Текст = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 по организации %2 уже введен счет-фактура %3'"),
					ДокументОснование,
					Организация,
					Выборка.Ссылка);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ЭтотОбъект,
				"ДокументОснование",
				,
				Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьСтрокуРасчетноПлатежныхДокументов()
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, "Номер, Дата");
	
	СтрокаНомеровИДата = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 от %2'"),
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(РеквизитыДокумента.Номер, Истина, Истина),
		Формат(РеквизитыДокумента.Дата, "ДЛФ=D"));
	
	Если СтрокаПлатежноРасчетныеДокументы <> СтрокаНомеровИДата Тогда
		СтрокаПлатежноРасчетныеДокументы = СтрокаНомеровИДата;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьСчетаФактурыОжидаетОплатыНДС(Проведен)
	
	СчетаФактуры = УчетНДСРФ.НоваяТаблицаСчетовФактур();
	СтрокаСчетаФактуры = СчетаФактуры.Добавить();
	СтрокаСчетаФактуры.СчетФактура = Ссылка;
	СтрокаСчетаФактуры.СуммаОплаты = РасшифровкаСуммы.Итог("СуммаНДС");
	СтрокаСчетаФактуры.ВидАгентскогоДоговора = ВидАгентскогоДоговора;
	СтрокаСчетаФактуры.ОплатаЧерезЕдиныйЛицевойСчет = (Дата >= РеглУчетСервер.ДатаНачалаОбязательногоПримененияЕНП());
	
	УчетНДСРФ.ЗарегистрироватьСчетаФактурыОжидаетОплатыНДС(СчетаФактуры, Ссылка, Проведен);

КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли

﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	// Проверка ОбменДанными.Загрузка не требуется, т.к. данный объект в РИБ при записи должен создавать задания.
	
	СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений = 
		ДополнительныеСвойства.Свойство("СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений")
		И ДополнительныеСвойства.СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений;
	
	Если СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений Тогда
		СвойстваДокумента = Новый Структура();
		СвойстваДокумента.Вставить("ЭтоНовый", Ложь);
		СвойстваДокумента.Вставить("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения);
		
		ДатаРегистратора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.Регистратор.Значение, "Дата");
		
		ДополнительныеСвойства.Вставить("СвойстваДокумента",       СвойстваДокумента);
		ДополнительныеСвойства.Вставить("ДатаРегистратора",        ДатаРегистратора);
		ДополнительныеСвойства.Вставить("РассчитыватьИзменения",   Истина);
		ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
		ДополнительныеСвойства.Вставить("ТаблицыКонтроля",         Новый Структура);
	КонецЕсли;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		И Не СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений Тогда
		Возврат;
	КонецЕсли;
	
	БлокироватьДляИзменения = Истина;
	
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	#Область ТекстЗапроса
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Таблица.Регистратор                  КАК Регистратор,
	|	Таблица.ОбъектРасчетов               КАК ОбъектРасчетов,
	|	Таблица.Валюта                       КАК Валюта,
	|	ВЫБОР КОГДА Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) ТОГДА
	|			ВЫБОР КОГДА Таблица.Сумма < 0 ТОГДА
	|					0
	|				ИНАЧЕ -Таблица.Сумма
	|			КОНЕЦ
	|		ИНАЧЕ Таблица.Сумма
	|	КОНЕЦ                                КАК СуммаПередЗаписью
	|
	|ПОМЕСТИТЬ РасчетыСПоставщикамиПередЗаписью
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И НЕ &ЭтоНовый
	|	И Таблица.ОбъектРасчетов.Объект <> НЕОПРЕДЕЛЕНО
	|	И НЕ &ОбменДанными
	|;
	|/////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расчеты.Период                         КАК Период,
	|	Расчеты.Регистратор                    КАК Регистратор,
	|	Расчеты.ВидДвижения                    КАК ВидДвижения,
	|	Расчеты.АналитикаУчетаПоПартнерам      КАК АналитикаУчетаПоПартнерам,
	|	Расчеты.ОбъектРасчетов                 КАК ОбъектРасчетов,
	|	Расчеты.Валюта                         КАК Валюта,
	|	Расчеты.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|	Расчеты.Сумма                          КАК Сумма,
	|	Расчеты.Оплачивается                   КАК Оплачивается,
	|	Расчеты.СуммаРегл                      КАК СуммаРегл,
	|	Расчеты.СуммаУпр                       КАК СуммаУпр,
	|	Расчеты.КОплате                        КАК КОплате,
	|	Расчеты.КПоступлению                   КАК КПоступлению,
	|	Расчеты.СтатьяДвиженияДенежныхСредств  КАК СтатьяДвиженияДенежныхСредств,
	|	Расчеты.ПорядокОперации                КАК ПорядокОперации,
	|	Расчеты.ПорядокЗачетаПоДатеПлатежа     КАК ПорядокЗачетаПоДатеПлатежа,
	|	Расчеты.РасчетныйДокумент              КАК РасчетныйДокумент,
	|	Расчеты.АналитикаУчетаПоПартнерамПриемник КАК АналитикаУчетаПоПартнерамПриемник,
	|	Расчеты.ОбъектРасчетовПриемник КАК ОбъектРасчетовПриемник,
	|	Расчеты.ВалютаПриемник КАК ВалютаПриемник,
	|	Расчеты.ПоДаннымОбъектаРасчетовИсточника КАК ПоДаннымОбъектаРасчетовИсточника,
	|	Расчеты.ВалютаДокумента                КАК ВалютаДокумента,
	|	Расчеты.ВариантОплаты                  КАК ВариантОплаты,
	|	Расчеты.ДатаПлатежа                    КАК ДатаПлатежа,
	|	Расчеты.ДатаРегистратора               КАК ДатаРегистратора,
	|	Расчеты.ЗакупкаПоЗаказу                КАК ЗакупкаПоЗаказу,
	|	Расчеты.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|	Расчеты.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	Расчеты.СвязанныйДокумент              КАК СвязанныйДокумент,
	|	Расчеты.Сторно                         КАК Сторно
	|ПОМЕСТИТЬ РасчетыСПоставщикамиИсходныеДвижения
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|ГДЕ
	|	Расчеты.Регистратор = &Регистратор
	|";
	#КонецОбласти
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Регистратор",  Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ЭтоНовый",     ДополнительныеСвойства.СвойстваДокумента.ЭтоНовый);
	Запрос.УстановитьПараметр("ОбменДанными", ОбменДанными.Загрузка);
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаОбъектовОплаты = СФормироватьТаблицуОбъектовОплаты();
	РегистрыСведений.ГрафикПлатежей.УстановитьБлокировкиДанныхДляРасчетаГрафика(
		ТаблицаОбъектовОплаты, "РегистрНакопления.РасчетыСПоставщиками", "ОбъектРасчетов", "ОбъектРасчетов");
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	// Проверка ОбменДанными.Загрузка не требуется, т.к. данный объект в РИБ при записи должен создавать задания.
	
	СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений = 
		ДополнительныеСвойства.Свойство("СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений")
		И ДополнительныеСвойства.СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений;
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		И Не СинхронизацияДанныхЧерезУниверсальныйФорматУдалениеДвижений Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	#Область ТекстЗапроса
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НАЧАЛОПЕРИОДА(Таблица.Период, МЕСЯЦ)   КАК Месяц,
	|	Таблица.Период                         КАК Период,
	|	Таблица.ПорядокОперации                КАК ПорядокОперации,
	|	Таблица.ПорядокЗачетаПоДатеПлатежа     КАК ПорядокЗачетаПоДатеПлатежа,
	|	Таблица.ПорядокОперации                КАК ПорядокФакт,
	|	Таблица.АналитикаУчетаПоПартнерам      КАК АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов                 КАК ОбъектРасчетов,
	|	Таблица.Валюта                         КАК ВалютаРасчетов,
	|	&Регистратор                           КАК Документ,
	|	СУММА(Таблица.Сумма)                   КАК Сумма,
	|	СУММА(Таблица.КОплате)                 КАК КОплате,
	|	СУММА(Таблица.КПоступлению)            КАК КПоступлению,
	|	СУММА(Таблица.СуммаРегл)               КАК СуммаРегл,
	|	СУММА(Таблица.СуммаУпр)                КАК СуммаУпр,
	|	Ключи.Организация                      КАК Организация,
	|	Таблица.АналитикаУчетаПоПартнерамПриемник КАК АналитикаУчетаПоПартнерамПриемник,
	|	Таблица.ОбъектРасчетовПриемник         КАК ОбъектРасчетовПриемник,
	|	Таблица.ВалютаПриемник                 КАК ВалютаПриемник,
	|	Таблица.ПоДаннымОбъектаРасчетовИсточника КАК ПоДаннымОбъектаРасчетовИсточника,
	|	ВЫБОР КОГДА Таблица.Сторно
	|			ТОГДА Таблица.СвязанныйДокумент
	|		ИНАЧЕ Таблица.Заказ
	|	КОНЕЦ                                  КАК Заказ,
	|	Таблица.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|	Таблица.РасчетныйДокумент              КАК РасчетныйДокумент,
	|	Таблица.ДатаПлатежа                    КАК ДатаПлатежа,
	|	Таблица.ДатаРегистратора               КАК ДатаРегистратора,
	|	Таблица.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|	Таблица.Сторно                         КАК Сторно,
	|	&РассчитыватьИзменения                      КАК ВызыватьИсключение
	|ПОМЕСТИТЬ РасчетыСПоставщикамиИзменения
	|ИЗ
	|	(ВЫБРАТЬ
	|		Расчеты.Период                         КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам      КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ОбъектРасчетов                 КАК ОбъектРасчетов,
	|		Расчеты.Валюта                         КАК Валюта,
	|		Расчеты.Сумма                          КАК Сумма,
	|		Расчеты.Оплачивается                   КАК Оплачивается,
	|		Расчеты.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|		Расчеты.СуммаРегл                      КАК СуммаРегл,
	|		Расчеты.СуммаУпр                       КАК СуммаУпр,
	|		Расчеты.КОплате                        КАК КОплате,
	|		Расчеты.КПоступлению                   КАК КПоступлению,
	|		Расчеты.СтатьяДвиженияДенежныхСредств  КАК СтатьяДвиженияДенежныхСредств,
	|		Расчеты.ПорядокОперации                КАК ПорядокОперации,
	|		Расчеты.ПорядокЗачетаПоДатеПлатежа     КАК ПорядокЗачетаПоДатеПлатежа,
	|		Расчеты.РасчетныйДокумент              КАК РасчетныйДокумент,
	|		Расчеты.АналитикаУчетаПоПартнерамПриемник КАК АналитикаУчетаПоПартнерамПриемник,
	|		Расчеты.ОбъектРасчетовПриемник         КАК ОбъектРасчетовПриемник,
	|		Расчеты.ВалютаПриемник         КАК ВалютаПриемник,
	|		Расчеты.ПоДаннымОбъектаРасчетовИсточника КАК ПоДаннымОбъектаРасчетовИсточника,
	|		Расчеты.ВалютаДокумента                КАК ВалютаДокумента,
	|		Расчеты.ВариантОплаты                  КАК ВариантОплаты,
	|		Расчеты.ДатаПлатежа                    КАК ДатаПлатежа,
	|		Расчеты.ДатаРегистратора               КАК ДатаРегистратора,
	|		Расчеты.ЗакупкаПоЗаказу                КАК Заказ,
	|		Расчеты.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|		Расчеты.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|		Расчеты.СвязанныйДокумент              КАК СвязанныйДокумент,
	|		Расчеты.Сторно                         КАК Сторно,
	|		ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма > 0
	|			ТОГДА 0
	|			КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма < 0
	|			ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ИндексДвиженияВзаимозачета
	|	ИЗ
	|		РасчетыСПоставщикамиИсходныеДвижения КАК Расчеты
	|		
	|	ОБЪЕДИНИТЬ ВСЕ
	|		
	|	ВЫБРАТЬ
	|		Расчеты.Период                         КАК Период,
	|		Расчеты.АналитикаУчетаПоПартнерам      КАК АналитикаУчетаПоПартнерам,
	|		Расчеты.ОбъектРасчетов                 КАК ОбъектРасчетов,
	|		Расчеты.Валюта                         КАК Валюта,
	|		-Расчеты.Сумма                         КАК Сумма,
	|		-Расчеты.Оплачивается                  КАК Оплачивается,
	|		Расчеты.ХозяйственнаяОперация          КАК ХозяйственнаяОперация,
	|		-Расчеты.СуммаРегл                     КАК СуммаРегл,
	|		-Расчеты.СуммаУпр                      КАК СуммаУпр,
	|		-Расчеты.КОплате                       КАК КОплате,
	|		-Расчеты.КПоступлению                  КАК КПоступлению,
	|		Расчеты.СтатьяДвиженияДенежныхСредств  КАК СтатьяДвиженияДенежныхСредств,
	|		Расчеты.ПорядокОперации                КАК ПорядокОперации,
	|		Расчеты.ПорядокЗачетаПоДатеПлатежа     КАК ПорядокЗачетаПоДатеПлатежа,
	|		Расчеты.РасчетныйДокумент              КАК РасчетныйДокумент,
	|		Расчеты.АналитикаУчетаПоПартнерамПриемник КАК АналитикаУчетаПоПартнерамПриемник,
	|		Расчеты.ОбъектРасчетовПриемник         КАК ОбъектРасчетовПриемник,
	|		Расчеты.ВалютаПриемник         КАК ВалютаПриемник,
	|		Расчеты.ПоДаннымОбъектаРасчетовИсточника КАК ПоДаннымОбъектаРасчетовИсточника,
	|		Расчеты.ВалютаДокумента                КАК ВалютаДокумента,
	|		Расчеты.ВариантОплаты                  КАК ВариантОплаты,
	|		Расчеты.ДатаПлатежа                    КАК ДатаПлатежа,
	|		Расчеты.ДатаРегистратора               КАК ДатаРегистратора,
	|		Расчеты.ЗакупкаПоЗаказу                КАК Заказ,
	|		Расчеты.НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации,
	|		Расчеты.ИдентификаторФинЗаписи         КАК ИдентификаторФинЗаписи,
	|		Расчеты.СвязанныйДокумент              КАК СвязанныйДокумент,
	|		Расчеты.Сторно                         КАК Сторно,
	|		ВЫБОР КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма > 0
	|			ТОГДА 0
	|			КОГДА ТИПЗНАЧЕНИЯ(Расчеты.Регистратор) = ТИП(Документ.ВзаимозачетЗадолженности)
	|				И Расчеты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) И Расчеты.Сумма < 0
	|			ТОГДА -1
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК ИндексДвиженияВзаимозачета
	|	ИЗ РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|	ГДЕ Расчеты.Регистратор = &Регистратор
	|) КАК Таблица
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК Ключи
	|	ПО Ключи.Ссылка = Таблица.АналитикаУчетаПоПартнерам
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов,
	|	Таблица.Валюта,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.СтатьяДвиженияДенежныхСредств,
	|	Таблица.РасчетныйДокумент,
	|	Таблица.АналитикаУчетаПоПартнерамПриемник,
	|	Таблица.ОбъектРасчетовПриемник,
	|	Таблица.ВалютаПриемник,
	|	Таблица.ПоДаннымОбъектаРасчетовИсточника,
	|	Таблица.ВалютаДокумента,
	|	Таблица.ВариантОплаты,
	|	Таблица.ДатаПлатежа,
	|	Таблица.ДатаРегистратора,
	|	Таблица.ИндексДвиженияВзаимозачета,
	|	Ключи.Организация,
	|	Таблица.ПорядокОперации,
	|	Таблица.ПорядокЗачетаПоДатеПлатежа,
	|	ВЫБОР КОГДА Таблица.Сторно
	|			ТОГДА Таблица.СвязанныйДокумент
	|		ИНАЧЕ Таблица.Заказ
	|	КОНЕЦ,
	|	Таблица.НастройкаХозяйственнойОперации,
	|	Таблица.ИдентификаторФинЗаписи,
	|	Таблица.Сторно
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Сумма) <> 0
	|	ИЛИ СУММА(Таблица.СуммаРегл) <> 0
	|	ИЛИ СУММА(Таблица.СуммаУпр) <> 0
	|	ИЛИ СУММА(Таблица.КОплате) <> 0
	|	ИЛИ СУММА(Таблица.Оплачивается) <> 0
	|	ИЛИ СУММА(Таблица.КПоступлению) <> 0";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса ="
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаИзменений.Документ                  КАК Регистратор,
	|	ТаблицаИзменений.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	ТаблицаИзменений.ОбъектРасчетов            КАК ОбъектРасчетов,
	|	ТаблицаИзменений.Период                    КАК Период,
	|	ТаблицаИзменений.Сумма                     КАК Сумма
	|	
	|ПОМЕСТИТЬ РасчетыСПоставщикамиИзмененияВводОстатков
	|ИЗ
	|	РасчетыСПоставщикамиИзменения КАК ТаблицаИзменений
	|ГДЕ
	|	ТаблицаИзменений.Сумма < 0
	|";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.АналитикаУчетаПоПартнерам,
	|	Таблица.ОбъектРасчетов,
	|	Таблица.Валюта,
	|	Таблица.ЗаявкаНаРасходованиеДенежныхСредств
	|ПОМЕСТИТЬ ДвиженияРасчетыСПоставщикамиИзменениеОплачивается
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И Таблица.Оплачивается <> 0
	|";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ РасчетыСПоставщикамиПередЗаписью");
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ РасчетыСПоставщикамиИсходныеДвижения");
	#КонецОбласти
	
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("НовыеРасчеты", ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов"));
	Запрос.УстановитьПараметр("РассчитыватьИзменения",    ПроведениеДокументов.РассчитыватьИзменения(ДополнительныеСвойства)
		И ТипЗнч(Отбор.Регистратор.Значение) <> Тип("ДокументСсылка.ВводОстатков")
		И ТипЗнч(Отбор.Регистратор.Значение) <> Тип("ДокументСсылка.ВводОстатковВзаиморасчетов"));
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	
	Результат = Запрос.ВыполнитьПакет();
	
	Выборка = Результат[0].Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"РасчетыСПоставщикамиИзменения", Выборка.Следующий() И Выборка.Количество > 0);
	Выборка = Результат[1].Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"РасчетыСПоставщикамиИзмененияВводОстатков", Выборка.Следующий() И Выборка.Количество > 0);
	Выборка = Результат[2].Выбрать();
	ПроведениеДокументов.ЗарегистрироватьТаблицуКонтроля(ДополнительныеСвойства,
		"ДвиженияРасчетыСПоставщикамиИзменениеОплачивается", Выборка.Следующий() И Выборка.Количество > 0);
	
	Если ОбменДанными.Загрузка Тогда
		// Задания к распределению расчетов формируются здесь для распределения расчетов при загрузке данных в РИБ
		ПараметрыИзменений = ОперативныеВзаиморасчетыСервер.ПараметрыРаспределенияРасчетов();
		ПараметрыИзменений.Регистратор = Отбор.Регистратор.Значение;
		ПараметрыИзменений.Загрузка = Истина;
		ПараметрыИзменений.ТаблицаИзменений = ОперативныеВзаиморасчетыСервер.ТаблицаИзмененийДляПересчета(
			Запрос.МенеджерВременныхТаблиц, Отбор.Регистратор.Значение);
		ПараметрыИзменений.РаспределениеСУчетомПриемников = Истина;
		ОперативныеВзаиморасчетыСервер.ЗарегистрироватьИзмененияКОтложенномуРаспределению(ПараметрыИзменений);
		РегистрыСведений.ВспомогательнаяИнформацияВзаиморасчетов.ЗаполнитьВспомогательнуюИнформацию(Запрос.МенеджерВременныхТаблиц, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует таблицу заказов, которые были раньше в движениях и которые сейчас будут записаны.
//
Функция СФормироватьТаблицуОбъектовОплаты()

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.УстановитьПараметр("ТаблицаНовыхОбъектовРасчетов", Выгрузить(, "ОбъектРасчетов"));
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Таблица.ОбъектРасчетов КАК ОбъектРасчетов
	|ПОМЕСТИТЬ ОбъектыРасчетов
	|ИЗ &ТаблицаНовыхОбъектовРасчетов КАК Таблица
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(Таблица.ОбъектРасчетов.Объект, &Регистратор) КАК ОбъектОплаты,
	|	Таблица.ОбъектРасчетов КАК ОбъектРасчетов
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Таблица
	|ГДЕ
	|	Таблица.Регистратор = &Регистратор
	|	И Таблица.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбъектыРасчетов.ОбъектРасчетов.Объект КАК ОбъектОплаты,
	|	ОбъектыРасчетов.ОбъектРасчетов КАК ОбъектРасчетов
	|ИЗ ОбъектыРасчетов
	|ГДЕ 
	|	ОбъектыРасчетов.ОбъектРасчетов.Объект <> Неопределено
	|";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ЗагрузитьСОбработкой(ТаблицаРасчетов) Экспорт
	
	ВзаиморасчетыСервер.ДобавитьЗаполнитьПорядокРасчетовСПоставщиками(ТаблицаРасчетов, ТипЗнч(Отбор.Регистратор.Значение));
	Загрузить(ТаблицаРасчетов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
